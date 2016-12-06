//
//  Router.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 06.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public final class Router {
    
    public let requestPerformer: RequestPerformer
    public let objectMapper: ObjectMapper
    
    public private(set) var requestEnhancers: [RequestEnhancer] = []
    
    public init(requestPerformer: RequestPerformer, objectMapperPolymorph: Polymorph? = nil) {
        self.requestPerformer = requestPerformer
        objectMapper = ObjectMapper(polymorph: objectMapperPolymorph)
        
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
    
    // TODO Different thread.
    fileprivate func run<IN, OUT>(endpoint: Endpoint<IN, OUT>, input: SupportedType, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        var request = prepareRequest(endpoint: endpoint, input: input)
        requestEnhancers.forEach { $0.enhance(request: &request) }
        
        return requestPerformer.perform(request: request) { response in
            self.requestEnhancers.forEach { $0.deenhance(response: response) }
            callback(response)
        }
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

extension Router {
    
    @discardableResult
    public func request(_ endpoint: Endpoint<SupportedType, SupportedType>, input: SupportedType, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint: endpoint, input: input, callback: callback)
    }
    
    @discardableResult
    public func request(_ endpoint: Endpoint<Void, Void>, callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint: endpoint, input: .null) { callback($0.map { _ in Void() }) }
    }
}



















