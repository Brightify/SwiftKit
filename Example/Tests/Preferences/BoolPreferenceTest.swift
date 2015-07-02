//
//  BoolPreferenceTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 25.05.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class BoolPreferenceTest: QuickSpec {

    override func spec() {
        describe("BoolPreference") {
            let parameters = [true, false]
            let key = "data"
            var preference: BoolPreference!
            
            beforeEach {
                preference = BoolPreference(key: key)
                preference.delete()
            }
            
            describe("value") {
                it("persists value") {
                    for parameter in parameters {
                        preference.value = parameter
                        
                        let savedValue = NSUserDefaults.standardUserDefaults().boolForKey(key)
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
                    let defaultValue = true
                    preference = BoolPreference(key: key, defaultValue: defaultValue)
                    preference.value = false
                    
                    preference.delete()
                    
                    expect(preference.value) == defaultValue
                }
            }
            
            describe("exists") {
                it("returns true if value exists") {
                    preference.value = true
                    
                    expect(preference.exists) == true
                }
                
                it("returns false if value doesn't exist") {
                    preference.delete()
                    
                    expect(preference.exists) == false
                }
                
                it("returns false if is value of different type") {
                    StringPreference(key: key).value = "Value of wrong type"
                    
                    expect(preference.exists) == false
                }
            }
            
            describe("delete") {
                it("deletes the value") {
                    preference.value = true
                    
                    preference.delete()
                    
                    let value: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(key)
                    expect(value).to(beNil())
                }
            }
            
            describe("onValueChange") {
                it("fires with correct input when value change") {
                    let value = true
                    var eventData: EventData<BoolPreference, Bool>?
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