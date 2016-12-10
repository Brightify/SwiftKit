//
//  ObjectMapper.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 28.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ObjectMapper {
    
    private let polymorph: Polymorph?
    
    public init(polymorph: Polymorph? = nil) {
        self.polymorph = polymorph
    }
    
    public func serialize<T: Serializable>(_ value: T?) -> SupportedType {
        var data = serializableData()
        data.set(value)
        return data.data
    }
    
    public func serialize<T: Serializable>(_ array: [T?]?) -> SupportedType {
        var data = serializableData()
        data.set(array)
        return data.data
    }
    
    public func serialize<T: Serializable>(_ dictionary: [String: T?]?) -> SupportedType {
        var data = serializableData()
        data.set(dictionary)
        return data.data
    }
    
    public func serialize<T, R: SerializableTransformation>(_ value: T?, using transformation: R) -> SupportedType where R.Object == T {
        var data = serializableData()
        data.set(value, using: transformation)
        return data.data
    }
    
    public func serialize<T, R: SerializableTransformation>(_ array: [T?]?, using transformation: R) -> SupportedType where R.Object == T {
        var data = serializableData()
        data.set(array, using: transformation)
        return data.data
    }
    
    public func serialize<T, R: SerializableTransformation>(_ dictionary: [String: T?]?, using transformation: R) -> SupportedType where R.Object == T {
        var data = serializableData()
        data.set(dictionary, using: transformation)
        return data.data
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType) -> T? {
        return deserializableData(data: type).get()
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType) -> [T]? {
        return deserializableData(data: type).get()
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType) -> [T?]? {
        return deserializableData(data: type).get()
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType) -> [String: T]? {
        return deserializableData(data: type).get()
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType) -> [String: T?]? {
        return deserializableData(data: type).get()
    }
    
    public func deserialize<T, R: DeserializableTransformation>(_ type: SupportedType, using transformation: R) -> T? where R.Object == T {
        return deserializableData(data: type).get(using: transformation)
    }
    
    public func deserialize<T, R: DeserializableTransformation>(_ type: SupportedType, using transformation: R) -> [T]? where R.Object == T {
        return deserializableData(data: type).get(using: transformation)
    }
    
    public func deserialize<T, R: DeserializableTransformation>(_ type: SupportedType, using transformation: R) -> [T?]? where R.Object == T {
        return deserializableData(data: type).get(using: transformation)
    }
    
    public func deserialize<T, R: DeserializableTransformation>(_ type: SupportedType, using transformation: R) -> [String: T]? where R.Object == T {
        return deserializableData(data: type).get(using: transformation)
    }
    
    public func deserialize<T, R: DeserializableTransformation>(_ type: SupportedType, using transformation: R) -> [String: T?]? where R.Object == T {
        return deserializableData(data: type).get(using: transformation)
    }
    
    public func serializableData() -> SerializableData {
        return SerializableData(polymorph: polymorph)
    }
    
    public func deserializableData(data: SupportedType) -> DeserializableData {
        return DeserializableData(data: data, polymorph: polymorph)
    }
}
