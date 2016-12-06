//
//  Router+RequestSupportedType.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 06.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

extension Router {
    
    @discardableResult
    public func request(_ endpoint: Endpoint<SupportedType, SupportedType>, input: SupportedType, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint, input: input, callback: callback)
    }
    
    @discardableResult
    public func request(_ endpoint: Endpoint<Void, SupportedType>, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint, input: .null, callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<IN, SupportedType>, input: IN, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<IN?, SupportedType>, input: IN?, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[IN], SupportedType>, input: [IN], callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[IN]?, SupportedType>, input: [IN]?, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[IN?], SupportedType>, input: [IN?], callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[IN?]?, SupportedType>, input: [IN?]?, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[String: IN], SupportedType>, input: [String: IN], callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[String: IN]?, SupportedType>, input: [String: IN]?, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[String: IN?], SupportedType>, input: [String: IN?], callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[String: IN?]?, SupportedType>, input: [String: IN?]?, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
}

extension Router {
    
    fileprivate func run<IN>(_ endpoint: Endpoint<IN, SupportedType>, input: SupportedType, callback: @escaping (Response<SupportedType>) -> ()) -> Cancellable {
        return run(endpoint: endpoint, input: input, callback: callback)
    }
}
