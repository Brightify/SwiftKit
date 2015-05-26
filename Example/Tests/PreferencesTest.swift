//
//  OptionalPreferenceTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 25.05.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Foundation

import UIKit
import XCTest
import SwiftKit

class PreferencesTest: XCTestCase {

    let key = "data";
    
    override func setUp() {
        super.setUp()
        
        OptionalPreference<NSString>(key: key).delete()
    }
    
    func testStringPreferences() {
        var preference = StringPreference(key: key)
        preference.value = "Hello"
        XCTAssertEqual(preference.value, "Hello")
    }
    
    func testIntPreferences() {
        var preference = IntPreference(key: key)
        preference.value = 3
        XCTAssertEqual(preference.value, 3)
    }
    
    func testFloatPreferences() {
        var preference = FloatPreference(key: key)
        preference.value = 3.234
        XCTAssertEqual(preference.value, 3.234)
    }
    
    func testDoublePreferences() {
        var preference = DoublePreference(key: key)
        preference.value = 3.234
        XCTAssertEqual(preference.value, 3.234)
    }
    
    func testBoolPreferences() {
        var preference = BoolPreference(key: key)
        preference.value = true
        XCTAssertEqual(preference.value, true)
    }
    
    func testArrayPreferences() {
        var preference = ArrayPreference<NSString>(key: key)
        preference.value.append("Hello")
        XCTAssertEqual(preference.value[0], "Hello")
    }
}