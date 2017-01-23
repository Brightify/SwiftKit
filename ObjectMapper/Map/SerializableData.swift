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
        if let array = array {
            data = .array(array.map { objectMapper.serialize($0) })
        } else {
            data = .null
        }
    }
    
    public mutating func set<T: Serializable>(_ dictionary: [String: T?]?) {
        if let dictionary = dictionary {
            data = .dictionary(dictionary.mapValue { objectMapper.serialize($0) })
        } else {
            data = .null
        }
    }
    
    public mutating func set<T, R: SerializableTransformation>(_ value: T?, using transformation: R) where R.Object == T {
        data = transformation.transform(object: value)
    }
    
    public mutating func set<T, R: SerializableTransformation>(_ array: [T?]?, using transformation: R) where R.Object == T {
        if let array = array?.map({ transformation.transform(object: $0) }) {
            data = .array(array)
        } else {
            data = .null
        }
    }
    
    public mutating func set<T, R: SerializableTransformation>(_ dictionary: [String: T?]?, using transformation: R) where R.Object == T {
        if let dictionary = dictionary?.mapValue({ transformation.transform(object: $0) }) {
            data = .dictionary(dictionary)
        } else {
            data = .null
        }
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
