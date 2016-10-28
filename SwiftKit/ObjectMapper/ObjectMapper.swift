//
//  ObjectMapper.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 28.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

// TODO ObjectMapper?
public struct ObjectMapper {
    
    private let polymorph: Polymorph?
    
    public init(polymorph: Polymorph?) {
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
    
    public func serializableData() -> SerializableData {
        return SerializableData(polymorph: polymorph)
    }
    
    public func deserializableData(data: SupportedType) -> DeserializableData {
        return DeserializableData(data: data, polymorph: polymorph)
    }
}
