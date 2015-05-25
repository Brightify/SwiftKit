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

    func testPreferences() {
        var preference = StringPreference(key: "data")
        preference.value = "Hello"
        XCTAssertEqual(preference.value, "Hello")
    }
    
}