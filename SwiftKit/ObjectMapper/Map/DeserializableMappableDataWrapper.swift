//
//  DeserializableMappableDataWrapper.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 23.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct DeserializableMappableDataWrapper: MappableData {
    
    private let delegate: DeserializableData
    
    init(delegate: DeserializableData) {
        self.delegate = delegate
    }
    
    public subscript(path: [String]) -> MappableData {
        return DeserializableMappableDataWrapper(delegate: delegate[path])
    }
    
    public subscript(path: String...) -> MappableData {
        return self[path]
    }
    
    public func map<T: SupportedTypeConvertible>(_ value: inout T?) {
        value = delegate.get()
    }
    
    public func map<T: SupportedTypeConvertible>(_ value: inout T, or: T) {
        value = delegate.get(or: or)
    }
    
    public func map<T: SupportedTypeConvertible>(_ array: inout [T]?) {
        array = delegate.get()
    }
    
    public func map<T: SupportedTypeConvertible>(_ array: inout [T]) {
        array = delegate.get()
    }
    
    public func map<T: SupportedTypeConvertible>(_ array: inout [T], or: [T]) {
        array = delegate.get(or: or)
    }
    
    public func map<T: Mappable>(_ value: inout T?) {
        value = delegate.get()
    }
    
    public func map<T: Mappable>(_ value: inout T, or: T) {
        value = delegate.get(or: or)
    }
    
    public func map<T: Mappable>(_ array: inout [T]?) {
        array = delegate.get()
    }
    
    public func map<T: Mappable>(_ array: inout [T]) {
        array = delegate.get()
    }
    
    public func map<T: Mappable>(_ array: inout [T], or: [T]) {
        array = delegate.get(or: or)
    }
    
    public func map<T, R: Transformation>(_ value: inout T?, using transformation: R) where R.Object == T {
        value = delegate.get(using: transformation)
    }
    
    public func map<T, R: Transformation>(_ value: inout T, using transformation: R, or: T) where R.Object == T {
        value = delegate.get(using: transformation, or: or)
    }
    
    public func map<T, R: Transformation>(_ array: inout [T]?, using transformation: R) where R.Object == T {
        array = delegate.get(using: transformation)
    }
    
    public func map<T, R: Transformation>(_ array: inout [T], using transformation: R) where R.Object == T {
        array = delegate.get(using: transformation)
    }
    
    public func map<T, R: Transformation>(_ array: inout [T], using transformation: R, or: [T]) where R.Object == T {
        array = delegate.get(using: transformation, or: or)
    }
}
