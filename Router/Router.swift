//
//  Router.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 06.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public final class Router {
    
    private static let syncQueue = DispatchQueue(label: "Router_syncQueue")
    
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
        Router.syncQueue.sync {
            self.requestEnhancers.append(contentsOf: requestEnhancers)
            self.requestEnhancers.sort { $0.priority.value > $1.priority.value }
        }
    }
    
    public func register(requestEnhancers: RequestEnhancer...) {
        register(requestEnhancers: requestEnhancers)
    }
    
    public func run<IN, OUT>(endpoint: Endpoint<IN, OUT>, inputProvider: @escaping () -> (SupportedType),
                    outputProvider: @escaping (SupportedType) -> OUT?, callback: @escaping (Response<OUT>) -> Void) -> Cancellable {
        let cancellable = Cancellable()
        callQueue.async {
            let wrappedCallback = self.wrap(callback: callback, with: outputProvider)
            let request = self.prepareRequest(endpoint: endpoint, input: inputProvider(), callback: wrappedCallback)
            
            self.perform(request: request)
            
            cancellable.add(cancellable: request.cancellable)
        }
        return cancellable
    }
    
    private func wrap<OUT>(callback: @escaping (Response<OUT>) -> Void,
                      with outputProvider: @escaping (SupportedType) -> OUT?) -> (Response<Data>) -> Void {
        return { response in
            self.callQueue.async {
                var decodedResponse = self.requestPerformer.dataEncoder.decode(response: response)
                self.requestEnhancers.forEach { $0.deenhance(response: &decodedResponse) }
                let mappedResponse = decodedResponse.flatMap { outputProvider($0).map { .success($0) } ?? .failure(.nilValue) }
                
                // Used if mappedResponse contains error. So this is only cast of generic type.
                // Allows ErrorHandler to respond to .nilValue.
                let mappedResponseForErrorHandler = mappedResponse.map { _ in SupportedType.null }
                if case .failure = mappedResponse.result, self.errorHandler.canResolveError(response: mappedResponseForErrorHandler) {
                    self.errorHandler.resolveError(response: mappedResponseForErrorHandler) {
                        // ErrorHandler can change response, so its neccesary to remap it again.
                        let mappedResponse = $0.flatMap { outputProvider($0).map { .success($0) } ?? .failure(.nilValue) }
                        self.callbackQueue.async { callback(mappedResponse) }
                    }
                } else {
                    self.callbackQueue.async { callback(mappedResponse) }
                }
            }
        }
    }
    
    private func prepareRequest<IN, OUT>(endpoint: Endpoint<IN, OUT>, input: SupportedType, callback: @escaping (Response<Data>) -> Void) -> Request {
        guard let url = URL(string: endpoint.path) else {
            preconditionFailure("Path \(endpoint.path) from endpoint doesn`t resolve to valid url.")
        }
        
        var request = Request(url: url, retry: retry, callback: callback, cancellable: Cancellable())
        request.httpMethod = endpoint.method
        request.modifiers = [endpoint.modifiers, requestPerformer.implicitModifiers].flatMap { $0 }
        
        switch endpoint.inputEncoding {
        case let inputEncoding as StandardInputEncoding:
            switch inputEncoding {
            case .httpBody:
                requestPerformer.dataEncoder.encodeToHttpBody(input: input, to: &request)
            case .queryString:
                requestPerformer.dataEncoder.encodeToQueryString(input: input, to: &request)
            }
        case let inputEncoding as InputEncodingWithEncoder:
            inputEncoding.encode(input: input, to: &request)
        default:
            requestPerformer.dataEncoder.encodeCustom(input: input, to: &request, inputEncoding: endpoint.inputEncoding)
        }
        
        requestEnhancers.forEach { $0.enhance(request: &request) }
        
        return request
    }
    
    private func perform(request: Request) {
        request.cancellable.add(cancellable: self.requestPerformer.perform(request: request, callback: request.callback))
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
