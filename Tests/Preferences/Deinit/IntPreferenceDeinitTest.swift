//
//  IntPreferenceDeinitTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 02.07.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import SwiftKit

class IntPreferenceDeinitTest: QuickSpec {
    
    override func spec() {
        describe("IntPreference") {
            let key = "data"
            
            beforeEach {
                TestableIntPreference(key: key).delete()
            }
            
            it("deinit") {
                QuickUtils.assertDeinit { TestableIntPreference(key: key) }
            }
            
            it("deinit if onValueChange is registered") {
                QuickUtils.assertDeinit {
                    let preference = TestableIntPreference(key: key)
                    preference.onValueChange += { _ in
                        
                    }
                    return preference
                }
            }
            
            it("deinit if value exists") {
                QuickUtils.assertDeinit {
                    let preference = TestableIntPreference(key: key)
                    preference.value = 10
                    return preference
                }
            }
        }
    }
    
}

private class TestableIntPreference: IntPreference, Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}