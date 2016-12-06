//
//  SupportedTypeConvertible.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol SupportedTypeConvertible: Mappable, SerializableSupportedTypeConvertible, DeserializableSupportedTypeConvertible {
    
    static var defaultTransformation: AnyTransformation<Self> { get }
}

extension SupportedTypeConvertible {
    
    public static var defaultSerializableTransformation: AnySerializableTransformation<Self> {
        return defaultTransformation.typeErased()
    }

    public static var defaultDeserializableTransformation: AnyDeserializableTransformation<Self> {
        return defaultTransformation.typeErased()
    }
}

extension SupportedTypeConvertible {
    
    public func serialize(to data: inout SerializableData) {
        do {
            try mapping(&data)
        }
        catch {
            preconditionFailure("Mapping called for serialization cannot throw exception.")
        }
    }
    
    public mutating func mapping(_ data: inout MappableData) throws {
        try data.map(&self, using: Self.defaultTransformation)
    }
}
