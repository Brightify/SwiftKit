//
//  CompositeDeserializableTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol CompositeDeserializableTransformation: DeserializableTransformation {
    
    associatedtype TransitiveObject
    
    var deserializableTransformationDelegate: AnyDeserializableTransformation<TransitiveObject> { get }
    
    func convert(from value: TransitiveObject?) -> Object?
}

extension CompositeDeserializableTransformation {
    
    public func transform(from value: SupportedType) -> Object? {
        return convert(from: deserializableTransformationDelegate.transform(from: value))
    }
}
