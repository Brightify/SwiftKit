//
//  Assert.swift
//  SwiftKit
//
//  Created by Filip Dolník on 28.06.15.
//
//

import XCTest
import SwiftKit

public struct Assert {
    
    private init() {
        
    }
    
    public static func notNil(expression: Any?, message: String = "") {
        XCTAssertTrue(expression != nil, message)
    }
    
}