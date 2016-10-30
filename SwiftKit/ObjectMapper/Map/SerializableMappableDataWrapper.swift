//
//  SerializableMappableDataWrapper.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 23.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct SerializableMappableDataWrapper: MappableData {
    
    public var delegate: SerializableData
    
    public init(delegate: SerializableData) {
        self.delegate = delegate
    }
    
    public subscript(path: [String]) -> MappableData {
        get {
            return SerializableMappableDataWrapper(delegate: delegate[path])
        }
        set {
            if let serializable = newValue as? SerializableMappableDataWrapper {
                delegate[path] = serializable.delegate
            }
        }
    }
    
    public subscript(path: String...) -> MappableData {
        get {
            return self[path]
        }
        set {
            self[path] = newValue
        }
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ value: inout T?) {
        delegate.set(value)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ value: inout T, or: T) {
        delegate.set(value)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ value: inout T) throws {
        delegate.set(value)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ array: inout [T]?) {
        delegate.set(array)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ array: inout [T], or: [T]) {
        delegate.set(array)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ array: inout [T]) throws {
        delegate.set(array)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ array: inout [T?]?) {
        delegate.set(array)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ array: inout [T?], or: [T?]) {
        delegate.set(array)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ array: inout [T?]) throws {
        delegate.set(array)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ dictionary: inout [String: T]?) {
        delegate.set(dictionary)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ dictionary: inout [String: T], or: [String: T]) {
        delegate.set(dictionary)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ dictionary: inout [String: T]) throws {
        delegate.set(dictionary)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ dictionary: inout [String: T?]?) {
        delegate.set(dictionary)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ dictionary: inout [String: T?], or: [String: T?]) {
        delegate.set(dictionary)
    }
    
    public mutating func map<T: SupportedTypeConvertible>(_ dictionary: inout [String: T?]) throws {
        delegate.set(dictionary)
    }
    
    public mutating func map<T: Mappable>(_ value: inout T?) {
        delegate.set(value)
    }
    
    public mutating func map<T: Mappable>(_ value: inout T, or: T) {
        delegate.set(value)
    }
    
    public mutating func map<T: Mappable>(_ value: inout T) throws {
        delegate.set(value)
    }
    
    public mutating func map<T: Mappable>(_ array: inout [T]?) {
        delegate.set(array)
    }
    
    public mutating func map<T: Mappable>(_ array: inout [T], or: [T]) {
        delegate.set(array)
    }
    
    public mutating func map<T: Mappable>(_ array: inout [T]) throws {
        delegate.set(array)
    }
    
    public mutating func map<T: Mappable>(_ array: inout [T?]?) {
        delegate.set(array)
    }
    
    public mutating func map<T: Mappable>(_ array: inout [T?], or: [T?]) {
        delegate.set(array)
    }
    
    public mutating func map<T: Mappable>(_ array: inout [T?]) throws {
        delegate.set(array)
    }
    
    public mutating func map<T: Mappable>(_ dictionary: inout [String: T]?) {
        delegate.set(dictionary)
    }
    
    public mutating func map<T: Mappable>(_ dictionary: inout [String: T], or: [String: T]) {
        delegate.set(dictionary)
    }
    
    public mutating func map<T: Mappable>(_ dictionary: inout [String: T]) throws {
        delegate.set(dictionary)
    }
    
    public mutating func map<T: Mappable>(_ dictionary: inout [String: T?]?) {
        delegate.set(dictionary)
    }
    
    public mutating func map<T: Mappable>(_ dictionary: inout [String: T?], or: [String: T?]) {
        delegate.set(dictionary)
    }
    
    public mutating func map<T: Mappable>(_ dictionary: inout [String: T?]) throws {
        delegate.set(dictionary)
    }
    
    public mutating func map<T, R: Transformation>(_ value: inout T?, using transformation: R) where R.Object == T {
        delegate.set(value, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ value: inout T, using transformation: R, or: T) where R.Object == T {
        delegate.set(value, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ value: inout T, using transformation: R) throws where R.Object == T {
        delegate.set(value, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ array: inout [T]?, using transformation: R) where R.Object == T {
        delegate.set(array, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ array: inout [T], using transformation: R, or: [T]) where R.Object == T {
        delegate.set(array, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ array: inout [T], using transformation: R) throws where R.Object == T {
        delegate.set(array, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ array: inout [T?]?, using transformation: R) where R.Object == T {
        delegate.set(array, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ array: inout [T?], using transformation: R, or: [T?]) where R.Object == T {
        delegate.set(array, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ array: inout [T?], using transformation: R) throws where R.Object == T {
        delegate.set(array, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ dictionary: inout [String: T]?, using transformation: R) where R.Object == T {
        delegate.set(dictionary, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ dictionary: inout [String: T], using transformation: R, or: [String: T]) where R.Object == T {
        delegate.set(dictionary, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ dictionary: inout [String: T], using transformation: R) throws where R.Object == T {
        delegate.set(dictionary, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ dictionary: inout [String: T?]?, using transformation: R) where R.Object == T {
        delegate.set(dictionary, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ dictionary: inout [String: T?], using transformation: R, or: [String: T?]) where R.Object == T {
        delegate.set(dictionary, using: transformation)
    }
    
    public mutating func map<T, R: Transformation>(_ dictionary: inout [String: T?], using transformation: R) throws where R.Object == T {
        delegate.set(dictionary, using: transformation)
    }
}
