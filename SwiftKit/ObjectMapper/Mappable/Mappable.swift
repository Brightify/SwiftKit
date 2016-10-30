//
//  Mappable.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol Mappable: Serializable, Deserializable {
    
    mutating func mapping(_ data: inout MappableData) throws
}

extension Mappable {
    
    // TODO Solve throws for serialize.
    public func serialize(to data: inout SerializableData) {
        do {
            try mapping(&data)
        }
        catch {
            preconditionFailure("Mapping called for serialization cannot throw exception.")
        }
    }
}

extension Mappable {
    
    public mutating func mapping(_ data: DeserializableData) throws {
        var wrapper: MappableData = DeserializableMappableDataWrapper(delegate: data)
        try mapping(&wrapper)
    }
    
    public func mapping(_ data: inout SerializableData) throws {
        var wrapper: MappableData = SerializableMappableDataWrapper(delegate: data)
        var s = self
        try s.mapping(&wrapper)
        if let wrapper = wrapper as? SerializableMappableDataWrapper {
            data = wrapper.delegate
        }
    }
}

// Mutating function from extension cannot be called on Class instance.
extension Mappable where Self: AnyObject {
    
    public func mapping(_ data: DeserializableData) throws {
        var wrapper: MappableData = DeserializableMappableDataWrapper(delegate: data)
        var s = self
        try s.mapping(&wrapper)
    }
}
