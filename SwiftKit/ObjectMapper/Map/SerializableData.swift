//
//  SerializableData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public class SerializableData {
    
    private let dataPointer: UnsafeMutablePointer<SupportedType>
    private let onDataUpdate: (SupportedType) -> Void
    private let pointerToDeallocate: UnsafeMutablePointer<SupportedType>?
    
    private var data: SupportedType {
        get {
            return dataPointer.pointee
        }
        set {
            dataPointer.pointee = newValue
            onDataUpdate(newValue)
        }
    }
    
    init(data: UnsafeMutablePointer<SupportedType>) {
        dataPointer = data
        onDataUpdate = { _ in }
        pointerToDeallocate = nil
    }
    
    private init(data: SupportedType?, onDataUpdate: @escaping (SupportedType) -> Void) {
        dataPointer = UnsafeMutablePointer<SupportedType>.allocate(capacity: 1)
        dataPointer.initialize(to: data ?? .dictionary([:]))
        self.onDataUpdate = onDataUpdate
        pointerToDeallocate = dataPointer
    }
    
    deinit {
        pointerToDeallocate?.deallocate(capacity: 1)
    }
    
    public subscript(path: [String]) -> SerializableData {
        return path.reduce(self) { serializableData, path in
            return SerializableData(data: serializableData.data.dictionary?[path]) { updatedType in
                var dictionary = serializableData.data.dictionary ?? [:]
                dictionary[path] = updatedType
                serializableData.data = .dictionary(dictionary)
            }
        }
    }
    
    public subscript(path: String...) -> SerializableData {
        return self[path]
    }
    
    public func set<T: SerializableSupportedTypeConvertible>(_ value: T?) {
        set(value, using: T.defaultSerializableTransformation)
    }
    
    public func set<T: SerializableSupportedTypeConvertible>(_ array: [T]?) {
        set(array, using: T.defaultSerializableTransformation)
    }
    
    public func set<T: Serializable>(_ value: T?) {
        if let value = value {
            data = value.serialized()
        } else {
            data = .null
        }
    }
    
    public func set<T: Serializable>(_ array: [T]?) {
        if let array = array?.map({ $0.serialized() }) {
            data = .array(array)
        } else {
            data = .null
        }
    }
    
    public func set<T, R: SerializableTransformation>(_ value: T?, using transformation: R) where R.Object == T {
        data = transformation.transform(object: value)
    }
    
    public func set<T, R: SerializableTransformation>(_ array: [T]?, using transformation: R) where R.Object == T {
        if let array = array?.map({ transformation.transform(object: $0) }) {
            data = .array(array)
        } else {
            data = .null
        }
    }
}
