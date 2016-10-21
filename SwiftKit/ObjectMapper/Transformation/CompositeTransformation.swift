//
//  CompositeTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public protocol CompositeTransformation: Transformation {
    
    associatedtype TransitiveObject
    
    var delegate: AnyTransformation<TransitiveObject> { get }
    
    func convert(from value: TransitiveObject?) -> Object?
    
    func convert(object: Object?) -> TransitiveObject?
}

extension CompositeTransformation {
    
    public func transform(from value: SupportedType) -> Object? {
        return convert(from: delegate.transform(from: value))
    }
    
    public func transform(object: Object?) -> SupportedType {
        return delegate.transform(object: convert(object: object))
    }
}
