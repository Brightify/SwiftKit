//
//  CompositeTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol CompositeTransformation: Transformation, CompositeSerializableTransformation, CompositeDeserializableTransformation {
    
    var transformationDelegate: AnyTransformation<TransitiveObject> { get }
}

extension CompositeTransformation {
    
    public var serializableTransformationDelegate: AnySerializableTransformation<TransitiveObject> {
        return transformationDelegate.typeErased()
    }
    
    public var deserializableTransformationDelegate: AnyDeserializableTransformation<TransitiveObject> {
        return transformationDelegate.typeErased()
    }
}
