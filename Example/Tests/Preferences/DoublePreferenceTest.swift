//
//  DoublePreferenceTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 25.05.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Foundation

import UIKit
import XCTest
import SwiftKit

class DoublePreferenceTest: XCTestCase {

    private let parameters = [-10.1234, 0, 10.1234]
    
    private let key = "data"
    
    private var preference: DoublePreference!
    
    override func setUp() {
        super.setUp()
        
        preference = DoublePreference(key: key)
        preference.delete()
    }
    
    func testSetValue_parametrizedValues_persistCorrectValue() {
        for parameter in parameters {
            preference.value = parameter
            
            let savedValue = NSUserDefaults.standardUserDefaults().doubleForKey(key)
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
        let defaultValue = 10.1
        preference = DoublePreference(key: key, defaultValue: defaultValue)
        preference.value = 0
        
        preference.delete()
        
        XCTAssertEqual(defaultValue, preference.value)
    }
    
    func testExists_existingValue_returnsTrue() {
        preference.value = 0
        
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
        let value = 10.1
        var eventData: EventData<DoublePreference, Double>? = nil
        preference.onValueChange.registerClosure { data in
            eventData = data
        }
        
        preference.value = value
        
        Assert.notNil(eventData)
        XCTAssertTrue(eventData!.input == value)
    }
    
}