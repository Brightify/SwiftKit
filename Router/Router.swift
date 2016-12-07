//
//  Router.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 06.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

// TODO Retry
public final class Router {
    
    public let requestPerformer: RequestPerformer
    public let objectMapper: ObjectMapper
    
    public let callQueue: DispatchQueue
    public let callbackQueue: DispatchQueue
    
    public private(set) var requestEnhancers: [RequestEnhancer] = []
    
    public init(requestPerformer: RequestPerformer, objectMapperPolymorph: Polymorph? = nil,
                callQueue: DispatchQueue = DispatchQueue.global(qos: .background), callbackQueue: DispatchQueue = DispatchQueue.main) {
        self.requestPerformer = requestPerformer
        objectMapper = ObjectMapper(polymorph: objectMapperPolymorph)
        self.callQueue = callQueue
        self.callbackQueue = callbackQueue
        
        register(requestEnhancers: HeaderRequestEnhancer())
        register(requestEnhancers: requestPerformer.implicitEnchancers)
    }
    
    public func register(requestEnhancers: [RequestEnhancer]) {
        self.requestEnhancers.append(contentsOf: requestEnhancers)
        self.requestEnhancers.sort { $0.priority.value > $1.priority.value }
    }
    
    public func register(requestEnhancers: RequestEnhancer...) {
        register(requestEnhancers: requestEnhancers)
    }
    
    internal func run<IN, OUT>(endpoint: Endpoint<IN, OUT>, input: SupportedType, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        let cancallable = Cancellable()
        
        callQueue.async {
            var request = self.prepareRequest(endpoint: endpoint, input: input)
            self.requestEnhancers.forEach { $0.enhance(request: &request) }
            
            let requestCancellable = self.requestPerformer.perform(request: request) { response in
                self.requestEnhancers.forEach { $0.deenhance(response: response) }
                
                self.callbackQueue.async { callback(response) }
            }
            cancallable.rewrite(with: requestCancellable)
        }
        
        return cancallable
    }
    
    private func prepareRequest<IN, OUT>(endpoint: Endpoint<IN, OUT>, input: SupportedType) -> Request {
        guard let url = URL(string: endpoint.path) else {
            preconditionFailure("Path\(endpoint.path) from endpoint doesn`t resolve to valid url.")
        }
        
        var request = Request(url: url)
        request.httpMethod = endpoint.method
        request.modifiers = [endpoint.modifiers, requestPerformer.implicitModifiers].flatMap { $0 }
        
        switch endpoint.inputEncoding {
        case let inputEncoding as StandardInputEncoding:
            switch inputEncoding {
            case .httpBody:
                requestPerformer.inputEncoder.encodeToHttpBody(input: input, to: &request)
            case .queryString:
                requestPerformer.inputEncoder.encodeToQueryString(input: input, to: &request)
            }
        case let inputEncoding as InputEncodingWithEncoder:
            inputEncoding.encode(input: input, to: &request)
        default:
            requestPerformer.inputEncoder.encodeCustom(input: input, to: &request, inputEncoding: endpoint.inputEncoding)
        }

        return request
    }
}
