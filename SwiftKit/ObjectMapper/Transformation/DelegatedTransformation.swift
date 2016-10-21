//
//  DelegatedTransformation.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public protocol DelegatedTransformation: Transformation {
    
    var delegate: AnyTransformation<Object> { get }
}

extension DelegatedTransformation {
    
    public func transform(from value: SupportedType) -> Object? {
        return delegate.transform(from: value)
    }
    
    public func transform(object: Object?) -> SupportedType {
        return delegate.transform(object: object)
    }
}
