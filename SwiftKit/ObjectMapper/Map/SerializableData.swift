//
//  SerializableData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct SerializableData {
    
    internal private(set) var data: SupportedType = .null
    
    internal init() {
    }
    
    private init(data: SupportedType) {
        self.data = data
    }
    
    public subscript(path: [String]) -> SerializableData {
        get {
            return path.reduce(self) { serializableData, path in
                return SerializableData(data: serializableData.data.dictionary?[path] ?? .null)
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
    
    public mutating func set<T: SerializableSupportedTypeConvertible>(_ value: T?) {
        set(value, using: T.defaultSerializableTransformation)
    }
    
    public mutating func set<T: SerializableSupportedTypeConvertible>(_ array: [T]?) {
        set(array, using: T.defaultSerializableTransformation)
    }
    
    public mutating func set<T: SerializableSupportedTypeConvertible>(_ dictionary: [String: T]?) {
        set(dictionary, using: T.defaultSerializableTransformation)
    }
    
    // TODO Extract
    public mutating func set<T: Serializable>(_ value: T?) {
        if let value = value {
            var serializableData = SerializableData()
            value.serialize(to: &serializableData)
            data = serializableData.data
        } else {
            data = .null
        }
    }
    
    public mutating func set<T: Serializable>(_ array: [T]?) {
        if let array = array {
            let arrayData: [SupportedType] = array.map { value in
                var serializableData = SerializableData()
                value.serialize(to: &serializableData)
                return serializableData.data
            }
            data = .array(arrayData)
        } else {
            data = .null
        }
    }
    
    public mutating func set<T: Serializable>(_ dictionary: [String: T]?) {
        if let dictionary = dictionary {
            let dictionaryData: [String: SupportedType] = dictionary.mapValue { value in
                var serializableData = SerializableData()
                value.serialize(to: &serializableData)
                return serializableData.data
            }
            data = .dictionary(dictionaryData)
        } else {
            data = .null
        }
    }
    
    public mutating func set<T, R: SerializableTransformation>(_ value: T?, using transformation: R) where R.Object == T {
        data = transformation.transform(object: value)
    }
    
    public mutating func set<T, R: SerializableTransformation>(_ array: [T]?, using transformation: R) where R.Object == T {
        if let array = array?.map({ transformation.transform(object: $0) }) {
            data = .array(array)
        } else {
            data = .null
        }
    }
    
    public mutating func set<T, R: SerializableTransformation>(_ dictionary: [String: T]?, using transformation: R) where R.Object == T {
        if let dictionary = dictionary?.mapValue({ transformation.transform(object: $0) }) {
            data = .dictionary(dictionary)
        } else {
            data = .null
        }
    }
    
    private subscript(path: String) -> SerializableData {
        get {
            return SerializableData(data: data.dictionary?[path] ?? .null)
        }
        set {
            data.addToDictionary(key: path, value: newValue.data)
        }
    }
}
