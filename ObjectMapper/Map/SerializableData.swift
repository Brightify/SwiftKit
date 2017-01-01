//
//  SerializableData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct SerializableData {
    
    public let objectMapper: ObjectMapper
    
    public var data: SupportedType
    
    public init(data: SupportedType = .null, objectMapper: ObjectMapper) {
        self.objectMapper = objectMapper
        self.data = data
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
        data = objectMapper.serialize(value)
    }
    
    public mutating func set<T: Serializable>(_ array: [T?]?) {
        data = objectMapper.serialize(array)
    }
    
    public mutating func set<T: Serializable>(_ dictionary: [String: T?]?) {
        data = objectMapper.serialize(dictionary)
    }
    
    public mutating func set<T, R: SerializableTransformation>(_ value: T?, using transformation: R) where R.Object == T {
        data = objectMapper.serialize(value, using: transformation)
    }
    
    public mutating func set<T, R: SerializableTransformation>(_ array: [T?]?, using transformation: R) where R.Object == T {
        data = objectMapper.serialize(array, using: transformation)
    }
    
    public mutating func set<T, R: SerializableTransformation>(_ dictionary: [String: T?]?, using transformation: R) where R.Object == T {
        data = objectMapper.serialize(dictionary, using: transformation)
    }
    
    private subscript(path: String) -> SerializableData {
        get {
            return SerializableData(data: data.dictionary?[path] ?? .null, objectMapper: objectMapper)
        }
        set {
            data.addToDictionary(key: path, value: newValue.data)
        }
    }
}
