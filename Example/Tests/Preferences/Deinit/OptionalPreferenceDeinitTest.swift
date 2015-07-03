//
//      PreferenceDeinitTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 02.07.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import SwiftKit

class OptionalPreferenceDeinitTest: QuickSpec {
    
    override func spec() {
        describe("OptionalPreference") {
            let key = "data"
            
            beforeEach {
                TestableOptionalPreference<NSString>(key: key).delete()
            }
            
            it("deinit") {
                QuickUtils.assertDeinit { TestableOptionalPreference<NSString>(key: key) }
            }
            
            it("deinit if onValueChange is registered") {
                QuickUtils.assertDeinit {
                    let preference = TestableOptionalPreference<NSString>(key: key)
                    preference.onValueChange += { _ in
                        
                    }
                    return preference
                }
            }
            
            it("deinit if value exists") {
                QuickUtils.assertDeinit {
                    let preference = TestableOptionalPreference<NSString>(key: key)
                    preference.value = "Hello"
                    return preference
                }
            }
        }
    }
    
}

private class TestableOptionalPreference<T: AnyObject>: OptionalPreference<T>, Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    required override init(key: String) {
        super.init(key: key)
    }
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}