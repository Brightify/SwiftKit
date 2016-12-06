//
//  DateFormatterTransformation.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public struct DateFormatterTransformation: Transformation {
    
    private let dateFormatter: DateFormatter
    
    public init(dateFormatter: DateFormatter) {
        self.dateFormatter = dateFormatter
    }
    
    public func transform(from value: SupportedType) -> Date? {
        return value.string.flatMap { dateFormatter.date(from: $0) }
    }
    
    public func transform(object: Date?) -> SupportedType {
        return object.map { .string(dateFormatter.string(from: $0)) } ?? .null
    }
}
