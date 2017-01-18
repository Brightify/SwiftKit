//
//  SerializableData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct SerializableData {
    
    public let objectMapper: ObjectMapper
    
    public var raw: SupportedType
    
    public init(data: SupportedType = .null, objectMapper: ObjectMapper) {
        self.objectMapper = objectMapper
        self.raw = data
    }
    
    public subscript(path: [String]) -> SerializableData {
        get {
            return path.reduce(self) { serializableData, path in
                return serializableData[path]
            }
        }
        set {
            if let last = path.last {
                self[Array(path.dropLast())][last] = newValue
            } else {
                self = newValue
            }
        }
    }
    
    public subscript(path: String...) -> SerializableData {
        get {
            return self[path]
        }
        set {
            self[path] = newValue
        }
    }

    public mutating func set<T: Serializable>(_ value: T?) {
        raw = objectMapper.serialize(value)
    }
    
    public mutating func set<T: Serializable>(_ array: [T?]?) {
        raw = objectMapper.serialize(array)
    }
    
    public mutating func set<T: Serializable>(_ dictionary: [String: T?]?) {
        raw = objectMapper.serialize(dictionary)
    }
    
    public mutating func set<T, R: SerializableTransformation>(_ value: T?, using transformation: R) where R.Object == T {
        raw = objectMapper.serialize(value, using: transformation)
    }
    
    public mutating func set<T, R: SerializableTransformation>(_ array: [T?]?, using transformation: R) where R.Object == T {
        raw = objectMapper.serialize(array, using: transformation)
    }
    
    public mutating func set<T, R: SerializableTransformation>(_ dictionary: [String: T?]?, using transformation: R) where R.Object == T {
        raw = objectMapper.serialize(dictionary, using: transformation)
    }
    
    private subscript(path: String) -> SerializableData {
        get {
            return SerializableData(data: raw.dictionary?[path] ?? .null, objectMapper: objectMapper)
        }
        set {
            raw.addToDictionary(key: path, value: newValue.raw)
        }
    }
}
