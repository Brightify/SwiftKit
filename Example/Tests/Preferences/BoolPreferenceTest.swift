//
//  BoolPreferenceTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 25.05.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Foundation

import UIKit
import XCTest
import SwiftKit

class BoolPreferenceTest: XCTestCase {

    let parameters = [false, true]
    
    private let key = "data"
    
    private var preference: BoolPreference!
    
    override func setUp() {
        super.setUp()
        
        preference = BoolPreference(key: key)
        preference.delete()
    }
    
    func testSetValue_parametrizedValues_persistCorrectValue() {
        for parameter in parameters {
            preference.value = parameter
            
            let savedValue = NSUserDefaults.standardUserDefaults().boolForKey(key)
            XCTAssertEqual(parameter, savedValue)
        }
    }
    
    func testGetValue_parametrizedValues_returnsSavedValue() {
        for parameter in parameters {
            preference.value = parameter

            XCTAssertEqual(parameter, preference.value)
        }
    }
    
    func testDelete_customDefaultValue_valueReturnsDefaultValue() {
        let defaultValue = true
        preference = BoolPreference(key: key, defaultValue: defaultValue)
        preference.value = false
        
        preference.delete()
        
        XCTAssertEqual(defaultValue, preference.value)
    }
    
    func testExists_existingValue_returnsTrue() {
        preference.value = true
        
        XCTAssertTrue(preference.exists)
    }
    
    func testExists_nonexistingValue_returnsFalse() {
        preference.delete()
        
        XCTAssertFalse(preference.exists)
    }
    
    func testExists_existingValueOfDifferentType_returnsFalse() {
        StringPreference(key: key).value = "Value of wrong type"
        
        XCTAssertFalse(preference.exists)
    }
    
    func testValue_changeOfValue_firesEventWithCorrectInput() {
        let value = true
        var eventData: EventData<BoolPreference, Bool>? = nil
        preference.onValueChange.registerClosure { data in
            eventData = data
        }
        
        preference.value = value
        
        XCTAssertNotNil(eventData)
        XCTAssertTrue(eventData!.input == value)
    }
    
}