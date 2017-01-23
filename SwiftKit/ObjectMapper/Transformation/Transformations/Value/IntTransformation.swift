//
//  IntTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public struct IntTransformation: Transformation {

    public init() {
    }
    
    public func transform(from value: SupportedType) -> Int? {
        return value.int
    }
    
    public func transform(object: Int?) -> SupportedType {
        return object.map(SupportedType.int) ?? .null
    }
}
