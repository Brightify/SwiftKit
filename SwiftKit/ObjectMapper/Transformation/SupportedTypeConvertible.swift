//
//  SupportedTypeConvertible.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol SupportedTypeConvertible: SerializableSupportedTypeConvertible, DeserializableSupportedTypeConvertible {
    
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
