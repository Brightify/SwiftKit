//
//  DateTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public struct DateTransformation: Transformation {
    
    public init() {
    }
    
    public func transform(from value: SupportedType) -> Date? {
        return value.double.map { Date(timeIntervalSince1970: $0) }
    }
    
    public func transform(object: Date?) -> SupportedType {
        return object.map { .double($0.timeIntervalSince1970) } ?? .null
    }
}
