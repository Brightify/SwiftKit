//
//  StringTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public struct StringTransformation: Transformation {
    
    public init() {
    }
    
    public func transform(from value: SupportedType) -> String? {
        return value.string
    }

    public func transform(object: String?) -> SupportedType {
        return object.map(SupportedType.string) ?? .null
    }
}
