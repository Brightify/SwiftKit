//
//  DelegatedTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol DelegatedTransformation: Transformation, DelegatedSerializableTransformation, DelegatedDeserializableTransformation {
    
    var transformationDelegate: AnyTransformation<Object> { get }
}

extension DelegatedTransformation {
    
    public var serializableTransformationDelegate: AnySerializableTransformation<Object> {
        return transformationDelegate.typeErased()
    }
    
    public var deserializableTransformationDelegate: AnyDeserializableTransformation<Object> {
        return transformationDelegate.typeErased()
    }
}
