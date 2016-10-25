//
//  DeserializableData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

// TODO What to do with nils in array caused by transformation. Both currently and previously they are discarded.

public struct DeserializableData {
    
    private let data: SupportedType
    
    init(data: SupportedType) {
        self.data = data
    }
    
    public subscript(path: [String]) -> DeserializableData {
        return path.reduce(self) { deserializableData, path in
            DeserializableData(data: deserializableData.data.dictionary?[path] ?? .null)
        }
    }
    
    public subscript(path: String...) -> DeserializableData {
        return self[path]
    }
    
    public func get<T: DeserializableSupportedTypeConvertible>() -> T? {
        return get(using: T.defaultDeserializableTransformation)
    }
    
    public func get<T: DeserializableSupportedTypeConvertible>(or: T) -> T {
        return get() ?? or
    }
    
    public func get<T: DeserializableSupportedTypeConvertible>() -> [T]? {
        return get(using: T.defaultDeserializableTransformation)
    }
    
    public func get<T: DeserializableSupportedTypeConvertible>(or: [T] = []) -> [T] {
        return get() ?? or
    }
    
    public func get<T: Deserializable>() -> T? {
        var s = self
        return T(&s)
    }
    
    public func get<T: Deserializable>(or: T) -> T {
        return get() ?? or
    }
    
    public func get<T: Deserializable>() -> [T]? {
        return data.array?.flatMap {
            var deserializableData = DeserializableData(data: $0)
            return T(&deserializableData)
        }
    }
    
    public func get<T: Deserializable>(or: [T] = []) -> [T] {
        return get() ?? or
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) -> T? where R.Object == T {
        return transformation.transform(from: data)
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R, or: T) -> T where R.Object == T {
        return get(using: transformation) ?? or
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R) -> [T]? where R.Object == T {
        return data.array?.flatMap { transformation.transform(from: $0) }
    }
    
    public func get<T, R: DeserializableTransformation>(using transformation: R, or: [T] = []) -> [T] where R.Object == T {
        return get(using: transformation) ?? or
    }
}
