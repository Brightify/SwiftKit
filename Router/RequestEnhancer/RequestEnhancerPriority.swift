//
//  RequestEnhancerPriority.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 04.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public enum RequestEnhancerPriority {
    
    case normal
    case low
    case high
    case max
    case custom(value: Int)
    
    public var value: Int {
        switch self {
        case .normal:
            return 0
        case .low:
            return -100
        case .high:
            return 100
        case .max:
            return 1000
        case .custom(let value):
            return value
        }
    }
}
