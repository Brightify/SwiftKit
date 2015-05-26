//
//  ArrayPreferenceTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 25.05.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Foundation

import UIKit
import XCTest
import SwiftKit

class ArrayPreferenceTest: XCTestCase {

    let array = ["Hello", "", "Gutten Tag"]
    
    private let key = "data"
    
    private var preference: ArrayPreference<NSString>!
    
    override func setUp() {
        super.setUp()
        
        preference = ArrayPreference<NSString>(key: key)
        preference.delete()
    }
    
    func testSetValue_arrayAsValue_persistCorrectValue() {
        preference.value = array
            
        let savedValue = NSUserDefaults.standardUserDefaults().objectForKey(key) as! [NSString]
        XCTAssertEqual(array, savedValue)
    }
    
    func testGetValue_arrayAsValue_returnsSavedValue() {
        preference.value = array
        
        XCTAssertEqual(array, preference.value)
    }
    
    func testDelete_customDefaultValue_valueReturnsDefaultValue() {
        let defaultValue = array
        preference = ArrayPreference<NSString>(key: key, defaultValue: defaultValue)
        preference.value = []
        
        preference.delete()
        
        XCTAssertEqual(defaultValue, preference.value)
    }
    
    func testExists_existingValue_returnsTrue() {
        preference.value = []
        
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
        let value = array
        var eventData: EventData<ArrayPreference<NSString>, [NSString]>? = nil
        preference.onValueChange.registerClosure { data in
            eventData = data
        }
        
        preference.value = value
        
        XCTAssertNotNil(eventData)
        XCTAssertTrue(eventData!.input == value)
    }
    
}