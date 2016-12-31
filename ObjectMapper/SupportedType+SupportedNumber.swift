//
//  SupportedType+SupportedNumber.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 30.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

extension SupportedType {
    
    public static func int(_ value: Int) -> SupportedType {
        return .number(SupportedNumber(int: value))
    }
    
    public static func double(_ value: Double) -> SupportedType {
        return .number(SupportedNumber(double: value))
    }
    
    public var int: Int? {
        return number?.int
    }
    
    public var double: Double? {
        return number?.double
    }
}
