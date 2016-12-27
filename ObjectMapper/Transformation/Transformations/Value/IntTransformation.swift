//
//  IntTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public struct IntTransformation: Transformation {

    public init() {
    }
    
    public func transform(from value: SupportedType) -> Int? {
        return value.number?.intValue
    }
    
    public func transform(object: Int?) -> SupportedType {
        return object.map(NSNumber.init(integerLiteral:)).map(SupportedType.number) ?? .null
    }
}
