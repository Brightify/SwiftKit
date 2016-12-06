//
//  DeserializableSupportedTypeConvertible.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol DeserializableSupportedTypeConvertible: Deserializable {
    
    static var defaultDeserializableTransformation: AnyDeserializableTransformation<Self> { get }
}

extension DeserializableSupportedTypeConvertible {
    
    public init(_ data: DeserializableData) throws {
        self = try data.get(using: Self.defaultDeserializableTransformation)
    }
}
