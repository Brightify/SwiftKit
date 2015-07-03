//
//  BoolPreferenceDeinitTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 02.07.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import SwiftKit

class BoolPreferenceDeinitTest: QuickSpec {
    
    override func spec() {
        describe("BoolPreference") {
            let key = "data"
            
            beforeEach {
                TestableBoolPreference(key: key).delete()
            }
            
            it("deinit") {
                QuickUtils.assertDeinit { TestableBoolPreference(key: key) }
            }
            
            it("deinit if onValueChange is registered") {
                QuickUtils.assertDeinit {
                    let preference = TestableBoolPreference(key: key)
                    preference.onValueChange += { _ in
                        
                    }
                    return preference
                }
            }
            
            it("deinit if value exists") {
                QuickUtils.assertDeinit {
                    let preference = TestableBoolPreference(key: key)
                    preference.value = true
                    return preference
                }
            }
        }
    }
    
}

private class TestableBoolPreference: BoolPreference, Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}