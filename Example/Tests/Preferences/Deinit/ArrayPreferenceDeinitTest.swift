//
//  ArrayPreferenceDeinitTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 02.07.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import SwiftKit

class ArrayPreferenceDeinitTest: QuickSpec {
    
    override func spec() {
        describe("ArrayPreference") {
            let key = "data"
            
            beforeEach {
                TestableArrayPreference<NSString>(key: key).delete()
            }
            
            it("deinit") {
                TestUtils.assertDeinit { TestableArrayPreference<NSString>(key: key) }
            }
            
            it("deinit if onValueChange is registered") {
                TestUtils.assertDeinit {
                    let preference = TestableArrayPreference<NSString>(key: key)
                    preference.onValueChange += { _ in
                        
                    }
                    return preference
                }
            }
            
            it("deinit if value exists") {
                TestUtils.assertDeinit {
                    let preference = TestableArrayPreference<NSString>(key: key)
                    preference.value = ["Hello"]
                    return preference
                }
            }
        }
    }
    
}

private class TestableArrayPreference<T: AnyObject>: ArrayPreference<T>, Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    required init(key: String, defaultValue: T = []) {
        super.init(key: key, defaultValue: defaultValue)
    }
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}