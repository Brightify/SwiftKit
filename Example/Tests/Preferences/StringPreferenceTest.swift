//
//  StringPreferenceTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 25.05.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Foundation

import UIKit
import XCTest
import SwiftKit

class StringPreferenceTest: XCTestCase {

    private let parameters = ["Hello", "", "Guten Tag"]
    
    private let key = "data"
    
    private var preference: StringPreference!
    
    override func setUp() {
        super.setUp()
        
        preference = StringPreference(key: key)
        preference.delete()
    }
    
    func testSetValue_parametrizedValues_persistCorrectValue() {
        for parameter in parameters {
            preference.value = parameter
            
            let savedValue = NSUserDefaults.standardUserDefaults().stringForKey(key)
            XCTAssertEqual(parameter, savedValue!)
        }
    }
    
    func testGetValue_parametrizedValues_returnsSavedValue() {
        for parameter in parameters {
            preference.value = parameter

            XCTAssertEqual(parameter, preference.value)
        }
    }
    
    func testDelete_customDefaultValue_valueReturnsDefaultValue() {
        let defaultValue = "Default value"
        preference = StringPreference(key: key, defaultValue: defaultValue)
        preference.value = "Real value"
        
        preference.delete()
        
        XCTAssertEqual(defaultValue, preference.value)
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
        var eventData: EventData<StringPreference, String>? = nil
        preference.onValueChange.registerClosure { data in
            eventData = data
        }
        
        preference.value = value
        
        XCTAssertNotNil(eventData)
        XCTAssertTrue(eventData!.input == value)
    }
    
}