//
//  AnyTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct AnyTransformation<T>: Transformation {
    
    private let transformFrom: (SupportedType) -> T?
    private let transformObject: (T?) -> SupportedType
    
    public init(transformFrom: @escaping (SupportedType) -> T?, transformObject: @escaping (T?) -> SupportedType) {
        self.transformFrom = transformFrom
        self.transformObject = transformObject
    }
    
    public func transform(from value: SupportedType) -> T? {
        return transformFrom(value)
    }
    
    public func transform(object: T?) -> SupportedType {
        return transformObject(object)
    }
}

extension Transformation {
    
    public func typeErased() -> AnyTransformation<Object> {
        return AnyTransformation(transformFrom: transform(from:), transformObject: transform(object:))
    }
}
