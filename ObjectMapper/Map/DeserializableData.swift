//
//  DeserializableData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct DeserializableData {
    
    public let raw: SupportedType
    public let objectMapper: ObjectMapper
    
    public init(data: SupportedType, objectMapper: ObjectMapper) {
        self.raw = data
        self.objectMapper = objectMapper
    }
    
    public subscript(path: [String]) -> DeserializableData {
        return path.reduce(self) { deserializableData, path in
            DeserializableData(data: deserializableData.raw.dictionary?[path] ?? .null, objectMapper: objectMapper)
        }
    }
    
    public subscript(path: String...) -> DeserializableData {
        return self[path]
    }
    
    public func get<T: Deserializable>() -> T? {
        return objectMapper.deserialize(raw)
    }
    
    public func get<T: Deserializable>(or: T) -> T {
        return get() ?? or
    }
    
    public func get<T: Deserializable>() throws -> T {
        return try valueOrThrow(get())
    }
    
    public func get<T: Deserializable>() -> [T]? {
        return objectMapper.deserialize(raw)
    }
    
    public func get<T: Deserializable>(or: [T]) -> [T] {
        return get() ?? or
    }
    
    public func get<T: Deserializable>() throws -> [T] {
        return try valueOrThrow(get())
    }
    
    public func get<T: Deserializable>() -> [T?]? {
        return objectMapper.deserialize(raw)
    }
    
    public func get<T: Deserializable>(or: [T?]) -> [T?] {
        return get() ?? or
    }
    
    public func get<T: Deserializable>() throws -> [T?] {
        return try valueOrThrow(get())
    }
    
    public func get<T: Deserializable>() -> [String: T]? {
        return objectMapper.deserialize(raw)
    }
    
    public func get<T: Deserializable>(or: [String: T]) -> [String: T] {
        return get() ?? or
    }
    
    public func get<T: Deserializable>() throws -> [String: T] {
        return try valueOrThrow(get())
    }
    
    public func get<T: Deserializable>() -> [String: T?]? {
        return objectMapper.deserialize(raw)
    }
    
    public func get<T: Deserializable>(or: [String: T?]) -> [String: T?] {
        return get() ?? or
    }
    
    public func get<T: Deserializable>() throws -> [String: T?] {
        return try valueOrThrow(get())
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) -> T? where R.Object == T {
        return objectMapper.deserialize(raw, using: transformation)
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R, or: T) -> T where R.Object == T {
        return get(using: transformation) ?? or
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) throws -> T where R.Object == T {
        return try valueOrThrow(get(using: transformation))
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) -> [T]? where R.Object == T {
        return objectMapper.deserialize(raw, using: transformation)
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R, or: [T]) -> [T] where R.Object == T {
        return get(using: transformation) ?? or
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) throws -> [T] where R.Object == T {
        return try valueOrThrow(get(using: transformation))
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) -> [T?]? where R.Object == T {
        return objectMapper.deserialize(raw, using: transformation)
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R, or: [T?]) -> [T?] where R.Object == T {
        return get(using: transformation) ?? or
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) throws -> [T?] where R.Object == T {
        return try valueOrThrow(get(using: transformation))
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) -> [String: T]? where R.Object == T {
        return objectMapper.deserialize(raw, using: transformation)
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R, or: [String: T]) -> [String: T] where R.Object == T {
        return get(using: transformation) ?? or
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) throws -> [String: T] where R.Object == T {
        return try valueOrThrow(get(using: transformation))
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) -> [String: T?]? where R.Object == T {
        return objectMapper.deserialize(raw, using: transformation)
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R, or: [String: T?]) -> [String: T?] where R.Object == T {
        return get(using: transformation) ?? or
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) throws -> [String: T?] where R.Object == T {
        return try valueOrThrow(get(using: transformation))
    }
    
    public func valueOrThrow<T>(_ optionalValue: T?) throws -> T {
        if let value = optionalValue {
            return value
        } else {
            throw DeserializationError.wrongType(type: raw)
        }
    }
}
