//
//  CompositeSerializableTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol CompositeSerializableTransformation: SerializableTransformation {
    
    associatedtype TransitiveObject
    
    var serializableTransformationDelegate: AnySerializableTransformation<TransitiveObject> { get }
    
    func convert(object: Object?) -> TransitiveObject?
}

extension CompositeSerializableTransformation {
    
    public func transform(object: Object?) -> SupportedType {
        return serializableTransformationDelegate.transform(object: convert(object: object))
    }
}
