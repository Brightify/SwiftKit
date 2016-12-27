//
//  AnyDeserializableTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 23.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct AnyDeserializableTransformation<T>: DeserializableTransformation {
    
    private let transformFrom: (SupportedType) -> T?
    
    public init(transformFrom: @escaping (SupportedType) -> T?) {
        self.transformFrom = transformFrom
    }
    
    public func transform(from value: SupportedType) -> T? {
        return transformFrom(value)
    }
}

extension DeserializableTransformation {
    
    public func typeErased() -> AnyDeserializableTransformation<Object> {
        return AnyDeserializableTransformation(transformFrom: transform(from:))
    }
}
