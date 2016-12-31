//
//  DeserializableData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct DeserializableData {
    
    public let data: SupportedType
    public let objectMapper: ObjectMapper
    
    public init(data: SupportedType, objectMapper: ObjectMapper) {
        self.data = data
        self.objectMapper = objectMapper
    }
    
    public subscript(path: [String]) -> DeserializableData {
        return path.reduce(self) { deserializableData, path in
            DeserializableData(data: deserializableData.data.dictionary?[path] ?? .null, objectMapper: objectMapper)
        }
    }
    
    public subscript(path: String...) -> DeserializableData {
        return self[path]
    }

    public func get<T: Deserializable>() -> T? {
        return objectMapper.deserialize(self.data)
    }
    
    public func get<T: Deserializable>(or: T) -> T {
        return get() ?? or
    }
    
    public func get<T: Deserializable>() throws -> T {
        return try valueOrThrow(get())
    }
    
    public func get<T: Deserializable>() -> [T]? {
        guard let array = data.array else {
            return nil
        }
        
        var result: [T] = []
        for type in array {
            if let value: T = objectMapper.deserialize(type) {
                result.append(value)
            } else {
                return nil
            }
        }
        return result
    }
    
    public func get<T: Deserializable>(or: [T]) -> [T] {
        return get() ?? or
    }
    
    public func get<T: Deserializable>() throws -> [T] {
        return try valueOrThrow(get())
    }
    
    public func get<T: Deserializable>() -> [T?]? {
        return data.array?.map { objectMapper.deserialize($0) }
    }
    
    public func get<T: Deserializable>(or: [T?]) -> [T?] {
        return get() ?? or
    }
    
    public func get<T: Deserializable>() throws -> [T?] {
        return try valueOrThrow(get())
    }
    
    public func get<T: Deserializable>() -> [String: T]? {
        guard let dictionary = data.dictionary else {
            return nil
        }
        
        var result: [String: T] = [:]
        for (key, type) in dictionary {
            if let value: T = objectMapper.deserialize(type) {
                result[key] = value
            } else {
                return nil
            }
        }
        return result
    }
    
    public func get<T: Deserializable>(or: [String: T]) -> [String: T] {
        return get() ?? or
    }
    
    public func get<T: Deserializable>() throws -> [String: T] {
        return try valueOrThrow(get())
    }
    
    public func get<T: Deserializable>() -> [String: T?]? {
        return data.dictionary?.mapValue { objectMapper.deserialize($0) }
    }
    
    public func get<T: Deserializable>(or: [String: T?]) -> [String: T?] {
        return get() ?? or
    }
    
    public func get<T: Deserializable>() throws -> [String: T?] {
        return try valueOrThrow(get())
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) -> T? where R.Object == T {
        return transformation.transform(from: data)
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R, or: T) -> T where R.Object == T {
        return get(using: transformation) ?? or
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) throws -> T where R.Object == T {
        return try valueOrThrow(get(using: transformation))
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) -> [T]? where R.Object == T {
        guard let array = data.array else {
            return nil
        }
        
        var result: [T] = []
        for type in array {
            if let value: T = transformation.transform(from: type) {
                result.append(value)
            } else {
                return nil
            }
        }
        return result
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R, or: [T]) -> [T] where R.Object == T {
        return get(using: transformation) ?? or
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) throws -> [T] where R.Object == T {
        return try valueOrThrow(get(using: transformation))
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) -> [T?]? where R.Object == T {
        return data.array?.map { transformation.transform(from: $0) }
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R, or: [T?]) -> [T?] where R.Object == T {
        return get(using: transformation) ?? or
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) throws -> [T?] where R.Object == T {
        return try valueOrThrow(get(using: transformation))
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) -> [String: T]? where R.Object == T {
        guard let dictionary = data.dictionary else {
            return nil
        }
        
        var result: [String: T] = [:]
        for (key, type) in dictionary {
            if let value: T = transformation.transform(from: type) {
                result[key] = value
            } else {
                return nil
            }
        }
        return result
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R, or: [String: T]) -> [String: T] where R.Object == T {
        return get(using: transformation) ?? or
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) throws -> [String: T] where R.Object == T {
        return try valueOrThrow(get(using: transformation))
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) -> [String: T?]? where R.Object == T {
        return data.dictionary?.mapValue { transformation.transform(from: $0) }
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
            throw DeserializationError.wrongType(type: data)
        }
    }
}
