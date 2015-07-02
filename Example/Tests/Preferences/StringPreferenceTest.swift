//
//  StringPreferenceTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 25.05.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class StringPreferenceTest: QuickSpec {
    
    override func spec() {
        describe("StringPreference") {
            let parameters = ["Hello", "", "Guten Tag"]
            let key = "data"
            var preference: StringPreference!
            
            beforeEach {
                preference = StringPreference(key: key)
                preference.delete()
            }
            
            describe("value") {
                it("persists value") {
                    for parameter in parameters {
                        preference.value = parameter
                        
                        let savedValue = NSUserDefaults.standardUserDefaults().stringForKey(key)
                        expect(savedValue) == parameter
                    }
                }
                
                it("returns saved value") {
                    for parameter in parameters {
                        preference.value = parameter
                        
                        expect(preference.value) == parameter
                    }
                }
                
                it("returns default value if value doesn't exist") {
                    let defaultValue = "Default value"
                    preference = StringPreference(key: key, defaultValue: defaultValue)
                    preference.value = "Real value"
                    
                    preference.delete()
                    
                    expect(preference.value) == defaultValue
                }
            }
            
            describe("exists") {
                it("returns true if value exists") {
                    preference.value = "Real value"
                    
                    expect(preference.exists) == true
                }
                
                it("returns false if value doesn't exist") {
                    preference.delete()
                    
                    expect(preference.exists) == false
                }
                
                it("returns false if is value of different type") {
                    IntPreference(key: key).value = 0
                    
                    expect(preference.exists) == false
                }
            }
            
            describe("delete") {
                it("deletes the value") {
                    preference.value = "Real value"
                    
                    preference.delete()
                    
                    let value: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(key)
                    expect(value).to(beNil())
                }
            }
            
            describe("onValueChange") {
                it("fires with correct input when value change") {
                    let value = "Real value"
                    var eventData: EventData<StringPreference, String>?
                    preference.onValueChange += { data in
                        eventData = data
                    }
                    
                    preference.value = value
                    
                    expect(eventData?.input) == value
                }
            }
        }
    }
    
}