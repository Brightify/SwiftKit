//
//  SupportedType+Equatable.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 30.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

extension SupportedType: Equatable {
}

public func ==(lhs: SupportedType, rhs: SupportedType) -> Bool {
    switch (lhs, rhs) {
    case (.null, .null):
        return true
    case (.string(let lValue), .string(let rValue)):
        return lValue == rValue
    case (.number(let lValue), .number(let rValue)):
        return lValue == rValue
    case (.bool(let lValue), .bool(let rValue)):
        return lValue == rValue
    case (.array(let lValue), .array(let rValue)):
        return lValue == rValue
    case (.dictionary(let lValue), .dictionary(let rValue)):
        return lValue == rValue
    default:
        return false
    }
}
