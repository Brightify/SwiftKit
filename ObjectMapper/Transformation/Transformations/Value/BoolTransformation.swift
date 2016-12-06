//
//  BoolTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct BoolTransformation: Transformation {

    public init() {
    }
    
    public func transform(from value: SupportedType) -> Bool? {
        return value.bool
    }
    
    public func transform(object: Bool?) -> SupportedType {
        return object.map(SupportedType.bool) ?? .null
    }
}
