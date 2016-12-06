//
//  Router+RequestOptionalDictionary.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 06.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

extension Router {
    
    @discardableResult
    public func request<OUT: Deserializable>(_ endpoint: Endpoint<SupportedType, [String: OUT?]>, input: SupportedType, callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint, input: input, callback: callback)
    }
    
    @discardableResult
    public func request<OUT: Deserializable>(_ endpoint: Endpoint<Void, [String: OUT?]>, callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint, input: .null, callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable, OUT: Deserializable>(_ endpoint: Endpoint<IN, [String: OUT?]>, input: IN, callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable, OUT: Deserializable>(_ endpoint: Endpoint<IN?, [String: OUT?]>, input: IN?, callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable, OUT: Deserializable>(_ endpoint: Endpoint<[IN], [String: OUT?]>, input: [IN], callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable, OUT: Deserializable>(_ endpoint: Endpoint<[IN]?, [String: OUT?]>, input: [IN]?, callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable, OUT: Deserializable>(_ endpoint: Endpoint<[IN?], [String: OUT?]>, input: [IN?], callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable, OUT: Deserializable>(_ endpoint: Endpoint<[IN?]?, [String: OUT?]>, input: [IN?]?, callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable, OUT: Deserializable>(_ endpoint: Endpoint<[String: IN], [String: OUT?]>, input: [String: IN], callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable, OUT: Deserializable>(_ endpoint: Endpoint<[String: IN]?, [String: OUT?]>, input: [String: IN]?, callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable, OUT: Deserializable>(_ endpoint: Endpoint<[String: IN?], [String: OUT?]>, input: [String: IN?], callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
    
    @discardableResult
    public func request<IN: Serializable, OUT: Deserializable>(_ endpoint: Endpoint<[String: IN?]?, [String: OUT?]>, input: [String: IN?]?, callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint, input: objectMapper.serialize(input), callback: callback)
    }
}

extension Router {
    
    fileprivate func run<IN, OUT: Deserializable>(_ endpoint: Endpoint<IN, [String: OUT?]>, input: SupportedType, callback: @escaping (Response<[String: OUT?]>) -> ()) -> Cancellable {
        return run(endpoint: endpoint, input: input) { (response: Response<SupportedType>) in
            callback(response.map { self.objectMapper.deserialize($0) ?? [:] })
        }
    }
}
