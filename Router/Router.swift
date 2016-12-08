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
    
    public func run<IN, OUT>(endpoint: Endpoint<IN, OUT>, input: SupportedType, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        var request = prepareRequest(endpoint: endpoint, input: input, callback: callback)
        self.requestEnhancers.forEach { $0.enhance(request: &request) }
        
        perform(request: request)
        
        return request.cancellable
    }
    
    private func perform(request: Request) {
        request.cancellable.add(cancellable: self.requestPerformer.perform(request: request) { response in
            self.requestEnhancers.forEach { $0.deenhance(response: response) }
            
            request.callback(response)
        })
    }
    
    private func prepareRequest<IN, OUT>(endpoint: Endpoint<IN, OUT>, input: SupportedType, callback: @escaping (Response<SupportedType>) -> ()) -> Request {
        guard let url = URL(string: endpoint.path) else {
            preconditionFailure("Path\(endpoint.path) from endpoint doesn`t resolve to valid url.")
        }
        
        var request = Request(url: url, retry: retry, callback: callback, cancellable: Cancellable())
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
    
    private func retry(request: Request, max: Int, delay: DispatchTime, failCallback: () -> ()) {
        guard request.retried < max else {
            return failCallback()
        }
        
        callQueue.asyncAfter(deadline: delay) {
            var requestCopy = request
            requestCopy.retried += 1
            self.perform(request: requestCopy)
        }
    }
}
