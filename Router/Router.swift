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
    public let errorHandler: ErrorHandler
    
    public let callQueue: DispatchQueue
    public let callbackQueue: DispatchQueue
    
    public private(set) var requestEnhancers: [RequestEnhancer] = []
    
    public init(requestPerformer: RequestPerformer, objectMapperPolymorph: Polymorph? = nil, errorHandler: ErrorHandler = NoErrorHandler(),
                callQueue: DispatchQueue = DispatchQueue.global(qos: .background), callbackQueue: DispatchQueue = DispatchQueue.main) {
        self.requestPerformer = requestPerformer
        objectMapper = ObjectMapper(polymorph: objectMapperPolymorph)
        self.errorHandler = errorHandler
        
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
    
    public func run<IN, OUT>(endpoint: Endpoint<IN, OUT>, inputProvider: @escaping () -> (SupportedType),
                    outputProvider: @escaping (SupportedType) -> OUT?, callback: @escaping (Response<OUT>) -> Void) -> Cancellable {
        let cancellable = Cancellable()
        callQueue.async {
            let request = self.prepareRequest(endpoint: endpoint, input: inputProvider()) { response in
                let mappedResponse = response.flatMap { outputProvider($0).map { .success($0) } ?? .failure(.nilValue) }
                self.callbackQueue.async { callback(mappedResponse) }
            }
            
            self.perform(request: request)
            
            cancellable.add(cancellable: request.cancellable)
        }
        return cancellable
    }
    
    private func perform(request: Request) {
        request.cancellable.add(cancellable: self.requestPerformer.perform(request: request) { response in
            var mutableResponse = response
            self.requestEnhancers.forEach { $0.deenhance(response: &mutableResponse) }
            
            if case .failure = mutableResponse.result, self.errorHandler.canResolveError(response: mutableResponse) {
                self.errorHandler.resolveError(response: mutableResponse) { request.callback($0) }
            } else {
                request.callback(mutableResponse)
            }
        })
    }
    
    private func prepareRequest<IN, OUT>(endpoint: Endpoint<IN, OUT>, input: SupportedType, callback: @escaping (Response<SupportedType>) -> Void) -> Request {
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
        
        requestEnhancers.forEach { $0.enhance(request: &request) }

        return request
    }
    
    private func retry(request: Request, max: Int, delay: DispatchTimeInterval, failCallback: () -> Void) {
        guard request.retried < max else {
            return failCallback()
        }
        
        callQueue.asyncAfter(deadline: DispatchTime.now() + delay) {
            var requestCopy = request
            requestCopy.retried += 1
            self.perform(request: requestCopy)
        }
    }
}
