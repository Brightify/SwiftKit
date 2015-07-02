//
//  FloatPreferenceDeinitTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 02.07.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import SwiftKit

class FloatPreferenceDeinitTest: QuickSpec {
    
    override func spec() {
        describe("FloatPreference") {
            let key = "data"
            
            beforeEach {
                TestableFloatPreference(key: key).delete()
            }
            
            it("deinit") {
                TestUtils.assertDeinit { TestableFloatPreference(key: key) }
            }
            
            it("deinit if onValueChange is registered") {
                TestUtils.assertDeinit {
                    let preference = TestableFloatPreference(key: key)
                    preference.onValueChange += { _ in
                        
                    }
                    return preference
                }
            }
            
            it("deinit if value exists") {
                TestUtils.assertDeinit {
                    let preference = TestableFloatPreference(key: key)
                    preference.value = 10.1
                    return preference
                }
            }
        }
    }
    
}

private class TestableFloatPreference: FloatPreference, Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}