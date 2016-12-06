//
//  Router+RequestVoid.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 06.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

extension Router {
    
    @discardableResult
    public func request(_ endpoint: Endpoint<SupportedType, Void>, input: SupportedType, callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint, input: input, callback: callback)
    }
    
    @discardableResult
    public func request(_ endpoint: Endpoint<Void, Void>, callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint, input: .null, callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<IN, Void>, input: IN, callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<IN?, Void>, input: IN?, callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[IN], Void>, input: [IN], callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[IN]?, Void>, input: [IN]?, callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[IN?], Void>, input: [IN?], callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[IN?]?, Void>, input: [IN?]?, callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[String: IN], Void>, input: [String: IN], callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[String: IN]?, Void>, input: [String: IN]?, callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[String: IN?], Void>, input: [String: IN?], callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable>(_ endpoint: Endpoint<[String: IN?]?, Void>, input: [String: IN?]?, callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
}

extension Router {
    
    fileprivate func run<IN>(_ endpoint: Endpoint<IN, Void>, input: SupportedType, callback: @escaping (Response<Void>) -> ()) -> Cancellable {
        return run(endpoint: endpoint, input: input) { callback($0.map { _ in Void() }) }
    }
}
