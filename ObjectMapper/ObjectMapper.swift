//
//  ObjectMapper.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 28.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public final class ObjectMapper {
    
    private let polymorph: Polymorph?
    
    public init(polymorph: Polymorph? = nil) {
        self.polymorph = polymorph
    }
    
    public func serialize<T: Serializable>(_ value: T?) -> SupportedType {
        if let value = value {
            var serializableData = SerializableData(objectMapper: self)
            value.serialize(to: &serializableData)
            var data = serializableData.raw
            polymorph?.writeTypeInfo(to: &data, of: type(of: value))
            return data
        } else {
            return .null
        }
    }
    
    public func serialize<T: Serializable>(_ array: [T?]?) -> SupportedType {
        if let array = array {
            return .array(array.map { serialize($0) })
        } else {
            return .null
        }
    }
    
    public func serialize<T: Serializable>(_ dictionary: [String: T?]?) -> SupportedType {
        if let dictionary = dictionary {
            return .dictionary(dictionary.mapValue { serialize($0) })
        } else {
            return .null
        }
    }
    
    public func serialize<T, R: SerializableTransformation>(_ value: T?, using transformation: R) -> SupportedType where R.Object == T {
        return transformation.transform(object: value)
    }
    
    public func serialize<T, R: SerializableTransformation>(_ array: [T?]?, using transformation: R) -> SupportedType where R.Object == T {
        if let array = array {
            return .array(array.map { transformation.transform(object: $0) })
        } else {
            return .null
        }
    }
    
    public func serialize<T, R: SerializableTransformation>(_ dictionary: [String: T?]?, using transformation: R) -> SupportedType where R.Object == T {
        if let dictionary = dictionary {
            return .dictionary(dictionary.mapValue { transformation.transform(object: $0) })
        } else {
            return .null
        }
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType) -> T? {
        let data = DeserializableData(data: type, objectMapper: self)
        let type = polymorph?.polymorphType(for: T.self, in: type) ?? T.self
        return try? type.init(data)
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType) -> [T]? {
        guard let array = type.array else {
            return nil
        }

        var result: [T] = []
        for type in array {
            if let value: T = deserialize(type) {
                result.append(value)
            } else {
                return nil
            }
        }
        return result
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType) -> [T?]? {
        return type.array?.map { deserialize($0) }
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType) -> [String: T]? {
        guard let dictionary = type.dictionary else {
            return nil
        }
        
        var result: [String: T] = [:]
        for (key, type) in dictionary {
            if let value: T = deserialize(type) {
                result[key] = value
            } else {
                return nil
            }
        }
        return result
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType) -> [String: T?]? {
        return type.dictionary?.mapValue { deserialize($0) }
    }
    
    public func deserialize<T, R: DeserializableTransformation>(_ type: SupportedType, using transformation: R) -> T? where R.Object == T {
        return transformation.transform(from: type)
    }
    
    public func deserialize<T, R: DeserializableTransformation>(_ type: SupportedType, using transformation: R) -> [T]? where R.Object == T {
        guard let array = type.array else {
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
    
    public func deserialize<T, R: DeserializableTransformation>(_ type: SupportedType, using transformation: R) -> [T?]? where R.Object == T {
        return type.array?.map { transformation.transform(from: $0) }
    }
    
    public func deserialize<T, R: DeserializableTransformation>(_ type: SupportedType, using transformation: R) -> [String: T]? where R.Object == T {
        guard let dictionary = type.dictionary else {
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
    
    public func deserialize<T, R: DeserializableTransformation>(_ type: SupportedType, using transformation: R) -> [String: T?]? where R.Object == T {
        return type.dictionary?.mapValue { transformation.transform(from: $0) }
    }
}
