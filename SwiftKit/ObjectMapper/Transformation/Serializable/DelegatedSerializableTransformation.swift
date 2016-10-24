//
//  DelegatedSerializableTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol DelegatedSerializableTransformation: SerializableTransformation {
    
    var serializableTransformationDelegate: AnySerializableTransformation<Object> { get }
}

extension DelegatedSerializableTransformation {
    
    public func transform(object: Object?) -> SupportedType {
        return serializableTransformationDelegate.transform(object: object)
    }
}
