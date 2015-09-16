//
//  StringPreferenceDeinitTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 02.07.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import SwiftKit

class StringPreferenceDeinitTest: QuickSpec {
    
    override func spec() {
        describe("StringPreference") {
            let key = "data"
            
            beforeEach {
                TestableStringPreference(key: key).delete()
            }
            
            it("deinit") {
                QuickUtils.assertDeinit { TestableStringPreference(key: key) }
            }
            
            it("deinit if onValueChange is registered") {
                QuickUtils.assertDeinit {
                    let preference = TestableStringPreference(key: key)
                    preference.onValueChange += { _ in
                        
                    }
                    return preference
                }
            }
            
            it("deinit if value exists") {
                QuickUtils.assertDeinit {
                    let preference = TestableStringPreference(key: key)
                    preference.value = "Real value"
                    return preference
                }
            }
        }
    }
    
}

private class TestableStringPreference: StringPreference, Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}