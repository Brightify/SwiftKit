//
//  SerializableMappableDataWrapper.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 23.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct SerializableMappableDataWrapper: MappableData {
    
    private let delegate: SerializableData
    
    init(delegate: SerializableData) {
        self.delegate = delegate
    }
    
    public subscript(path: [String]) -> MappableData {
        return SerializableMappableDataWrapper(delegate: delegate[path])
    }
    
    public subscript(path: String...) -> MappableData {
        return self[path]
    }
    
    public func map<T: SupportedTypeConvertible>(_ value: inout T?) {
        delegate.set(value)
    }
    
    public func map<T: SupportedTypeConvertible>(_ value: inout T, or: T) {
        delegate.set(value)
    }
    
    public func map<T: SupportedTypeConvertible>(_ array: inout [T]?) {
        delegate.set(array)
    }
    
    public func map<T: SupportedTypeConvertible>(_ array: inout [T]) {
        delegate.set(array)
    }
    
    public func map<T: SupportedTypeConvertible>(_ array: inout [T], or: [T]) {
        delegate.set(array)
    }
    
    public func map<T: Mappable>(_ value: inout T?) {
        delegate.set(value)
    }
    
    public func map<T: Mappable>(_ value: inout T, or: T) {
        delegate.set(value)
    }
    
    public func map<T: Mappable>(_ array: inout [T]?) {
        delegate.set(array)
    }
    
    public func map<T: Mappable>(_ array: inout [T]) {
        delegate.set(array)
    }
    
    public func map<T: Mappable>(_ array: inout [T], or: [T]) {
        delegate.set(array)
    }
    
    public func map<T, R: Transformation>(_ value: inout T?, using transformation: R) where R.Object == T {
        delegate.set(value, using: transformation)
    }
    
    public func map<T, R: Transformation>(_ value: inout T, using transformation: R, or: T) where R.Object == T {
        delegate.set(value, using: transformation)
    }
    
    public func map<T, R: Transformation>(_ array: inout [T]?, using transformation: R) where R.Object == T {
        delegate.set(array, using: transformation)
    }
    
    public func map<T, R: Transformation>(_ array: inout [T], using transformation: R) where R.Object == T {
        delegate.set(array, using: transformation)
    }
    
    public func map<T, R: Transformation>(_ array: inout [T], using transformation: R, or: [T]) where R.Object == T {
        delegate.set(array, using: transformation)
    }
}
