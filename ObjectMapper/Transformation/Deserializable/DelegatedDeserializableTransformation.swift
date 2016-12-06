//
//  DelegatedDeserializableTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol DelegatedDeserializableTransformation: DeserializableTransformation {
    
    var deserializableTransformationDelegate: AnyDeserializableTransformation<Object> { get }
}

extension DelegatedDeserializableTransformation {
    
    public func transform(from value: SupportedType) -> Object? {
        return deserializableTransformationDelegate.transform(from: value)
    }
}
