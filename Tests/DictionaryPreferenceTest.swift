//
//  DictionaryPreferenceTest.swift
//  SwiftKit
//
//  Created by Maros Seleng on 10/01/16.
//  Copyright © 2016 Brightify.org. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class DictionaryPreferenceTest: QuickSpec {
    override func spec() {
        describe("ArrayPreference") {
            let parameter = ["Hello":"World", "Gutten":"Tag"]
            let key = "data"
            var preference: DictionaryPreference<NSString, NSString>!
            
            beforeEach {
                preference = DictionaryPreference<NSString, NSString>(key: key)
                preference.delete()
            }
            
            describe("value") {
                it("persists value") {
                    preference.value = parameter
                    
                    let savedValue = NSUserDefaults.standardUserDefaults().objectForKey(key) as? [NSString:NSString]
                    expect(savedValue) == parameter
                }
                
                it("returns saved value") {
                    preference.value = parameter
                    
                    expect(preference.value) == parameter
                }
                
                it("returns default value if value doesn't exist") {
                    let defaultValue = parameter
                    preference = DictionaryPreference<NSString, NSString>(key: key, defaultValue: defaultValue)
                    preference.value = [:]
                    
                    preference.delete()
                    
                    expect(preference.value) == defaultValue
                }
            }
            
            describe("exists") {
                it("returns true if value exists") {
                    preference.value = [:]
                    
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
                    preference.value = parameter
                    
                    preference.delete()
                    
                    let value: AnyObject? = NSUserDefaults.standardUserDefaults().objectForKey(key)
                    expect(value).to(beNil())
                }
            }
            
            describe("onValueChange") {
                it("fires with correct input when value change") {
                    var eventData: EventData<DictionaryPreference<NSString, NSString>, [NSString:NSString]>?
                    preference.onValueChange += { data in
                        eventData = data
                    }
                    
                    preference.value = parameter
                    
                    expect(eventData?.input) == parameter
                }
            }
        }
    }
}
