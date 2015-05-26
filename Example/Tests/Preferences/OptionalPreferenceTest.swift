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

class OptionalPreferenceTest: XCTestCase {

    let parameters: [NSString?] = ["Hello", "", "Guten Tag", nil]
    
    private let key = "data"
    
    private var preference: OptionalPreference<NSString>!
    
    override func setUp() {
        super.setUp()
        
        preference = OptionalPreference<NSString>(key: key)
        preference.delete()
    }
    
    func testSetValue_parametrizedValues_persistCorrectValue() {
        for parameter in parameters {
            preference.value = parameter
            
            let savedValue = NSUserDefaults.standardUserDefaults().objectForKey(key) as? NSString
            XCTAssertTrue(parameter == savedValue)
        }
    }
    
    func testGetValue_parametrizedValues_returnsSavedValue() {
        for parameter in parameters {
            preference.value = parameter

            XCTAssertTrue(parameter == preference.value)
        }
    }
    
    func testDelete_existingValue_valueReturnsNil() {
        preference.value = "Real value"
        
        preference.delete()
        
        XCTAssertNil(preference.value)
    }
    
    func testExists_existingValue_returnsTrue() {
        preference.value = "Real value"
        
        XCTAssertTrue(preference.exists)
    }
    
    func testExists_nonexistingValue_returnsFalse() {
        preference.delete()
        
        XCTAssertFalse(preference.exists)
    }
    
    func testExists_existingValueOfDifferentType_returnsFalse() {
        IntPreference(key: key).value = 0
        
        XCTAssertFalse(preference.exists)
    }
    
    func testValue_changeOfValue_firesEventWithCorrectInput() {
        let value = "Real value"
        var eventData: EventData<OptionalPreference<NSString>, NSString?>? = nil
        preference.onValueChange.registerClosure { data in
            eventData = data
        }
        
        preference.value = value

        XCTAssertNotNil(eventData)
        XCTAssertTrue(eventData!.input == value)
    }
    
}