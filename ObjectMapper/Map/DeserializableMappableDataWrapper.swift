//
//  DeserializableMappableDataWrapper.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 23.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct DeserializableMappableDataWrapper: MappableData {
    
    public let delegate: DeserializableData
    
    public init(delegate: DeserializableData) {
        self.delegate = delegate
    }
    
    public subscript(path: [String]) -> MappableData {
        get {
            return DeserializableMappableDataWrapper(delegate: delegate[path])
        }
        set {
            // Intentionally left empty to conform protocol requirements.
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
    
    public func map<T: SerializableAndDeserializable>(_ value: inout T?) {
        value = delegate.get()
    }
    
    public func map<T: SerializableAndDeserializable>(_ value: inout T, or: T) {
        value = delegate.get(or: or)
    }
    
    public func map<T: SerializableAndDeserializable>(_ value: inout T) throws {
        value = try delegate.get()
    }
    
    public func map<T: SerializableAndDeserializable>(_ array: inout [T]?) {
        array = delegate.get()
    }
    
    public func map<T: SerializableAndDeserializable>(_ array: inout [T], or: [T]) {
        array = delegate.get(or: or)
    }
    
    public func map<T: SerializableAndDeserializable>(_ array: inout [T]) throws {
        array = try delegate.get()
    }
    
    public func map<T: SerializableAndDeserializable>(_ array: inout [T?]?) {
        array = delegate.get()
    }
    
    public func map<T: SerializableAndDeserializable>(_ array: inout [T?], or: [T?]) {
        array = delegate.get(or: or)
    }
    
    public func map<T: SerializableAndDeserializable>(_ array: inout [T?]) throws {
        array = try delegate.get()
    }
    
    public func map<T: SerializableAndDeserializable>(_ dictionary: inout [String: T]?) {
        dictionary = delegate.get()
    }
    
    public func map<T: SerializableAndDeserializable>(_ dictionary: inout [String: T], or: [String: T]) {
        dictionary = delegate.get(or: or)
    }
    
    public func map<T: SerializableAndDeserializable>(_ dictionary: inout [String: T]) throws {
        dictionary = try delegate.get()
    }
    
    public func map<T: SerializableAndDeserializable>(_ dictionary: inout [String: T?]?) {
        dictionary = delegate.get()
    }
    
    public func map<T: SerializableAndDeserializable>(_ dictionary: inout [String: T?], or: [String: T?]) {
        dictionary = delegate.get(or: or)
    }
    
    public func map<T: SerializableAndDeserializable>(_ dictionary: inout [String: T?]) throws {
        dictionary = try delegate.get()
    }
    
    public func map<T, R: Transformation>(_ value: inout T?, using transformation: R) where R.Object == T {
        value = delegate.get(using: transformation)
    }
    
    public func map<T, R: Transformation>(_ value: inout T, using transformation: R, or: T) where R.Object == T {
        value = delegate.get(using: transformation, or: or)
    }
    
    public func map<T, R: Transformation>(_ value: inout T, using transformation: R) throws where R.Object == T {
        value = try delegate.get(using: transformation)
    }
    
    public func map<T, R: Transformation>(_ array: inout [T]?, using transformation: R) where R.Object == T {
        array = delegate.get(using: transformation)
    }
    
    public func map<T, R: Transformation>(_ array: inout [T], using transformation: R, or: [T]) where R.Object == T {
        array = delegate.get(using: transformation, or: or)
    }
    
    public func map<T, R: Transformation>(_ array: inout [T], using transformation: R) throws where R.Object == T {
        array = try delegate.get(using: transformation)
    }
    
    public func map<T, R: Transformation>(_ array: inout [T?]?, using transformation: R) where R.Object == T {
        array = delegate.get(using: transformation)
    }
    
    public func map<T, R: Transformation>(_ array: inout [T?], using transformation: R, or: [T?]) where R.Object == T {
        array = delegate.get(using: transformation, or: or)
    }
    
    public func map<T, R: Transformation>(_ array: inout [T?], using transformation: R) throws where R.Object == T {
        array = try delegate.get(using: transformation)
    }
    
    public func map<T, R: Transformation>(_ dictionary: inout [String: T]?, using transformation: R) where R.Object == T {
        dictionary = delegate.get(using: transformation)
    }
    
    public func map<T, R: Transformation>(_ dictionary: inout [String: T], using transformation: R, or: [String: T]) where R.Object == T {
        dictionary = delegate.get(using: transformation, or: or)
    }
    
    public func map<T, R: Transformation>(_ dictionary: inout [String: T], using transformation: R) throws where R.Object == T {
        dictionary = try delegate.get(using: transformation)
    }
    
    public func map<T, R: Transformation>(_ dictionary: inout [String: T?]?, using transformation: R) where R.Object == T {
        dictionary = delegate.get(using: transformation)
    }
    
    public func map<T, R: Transformation>(_ dictionary: inout [String: T?], using transformation: R, or: [String: T?]) where R.Object == T {
        dictionary = delegate.get(using: transformation, or: or)
    }
    
    public func map<T, R: Transformation>(_ dictionary: inout [String: T?], using transformation: R) throws where R.Object == T {
        dictionary = try delegate.get(using: transformation)
    }
}
