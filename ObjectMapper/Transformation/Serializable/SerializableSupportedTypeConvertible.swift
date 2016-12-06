//
//  SerializableSupportedTypeConvertible.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol SerializableSupportedTypeConvertible: Serializable {
    
    static var defaultSerializableTransformation: AnySerializableTransformation<Self> { get }
}

extension SerializableSupportedTypeConvertible {
    
    public func serialize(to data: inout SerializableData) {
        data.set(self, using: Self.defaultSerializableTransformation)
    }
}
