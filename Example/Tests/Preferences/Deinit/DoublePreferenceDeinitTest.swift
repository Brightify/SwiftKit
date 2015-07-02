//
//  DoublePreferenceDeinitTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 02.07.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import SwiftKit

class DoublePreferenceDeinitTest: QuickSpec {
    
    override func spec() {
        describe("DoublePreference") {
            let key = "data"
            
            beforeEach {
                TestableDoublePreference(key: key).delete()
            }
            
            it("deinit") {
                TestUtils.assertDeinit { TestableDoublePreference(key: key) }
            }
            
            it("deinit if onValueChange is registered") {
                TestUtils.assertDeinit {
                    let preference = TestableDoublePreference(key: key)
                    preference.onValueChange += { _ in
                        
                    }
                    return preference
                }
            }
            
            it("deinit if value exists") {
                TestUtils.assertDeinit {
                    let preference = TestableDoublePreference(key: key)
                    preference.value = 10.1
                    return preference
                }
            }
        }
    }
    
}

private class TestableDoublePreference: DoublePreference, Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}