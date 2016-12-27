//
//  DoubleTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public struct DoubleTransformation: Transformation {
    
    public init() {
    }
    
    public func transform(from value: SupportedType) -> Double? {
        return value.number?.doubleValue
    }
    
    public func transform(object: Double?) -> SupportedType {
        return object.map(NSNumber.init(value:)).map(SupportedType.number) ?? .null
    }
}
