//
//  AnySerializableTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 23.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct AnySerializableTransformation<T>: SerializableTransformation {
    
    private let transformObject: (T?) -> SupportedType
    
    public init(transformObject: @escaping (T?) -> SupportedType) {
        self.transformObject = transformObject
    }
    
    public func transform(object: T?) -> SupportedType {
        return transformObject(object)
    }
}

extension SerializableTransformation {
    
    public func typeErased() -> AnySerializableTransformation<Object> {
        return AnySerializableTransformation(transformObject: transform(object:))
    }
}
