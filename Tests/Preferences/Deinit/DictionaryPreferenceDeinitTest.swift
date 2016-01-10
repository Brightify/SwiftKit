//
//  DictionaryPreferenceDeinitTest.swift
//  SwiftKit
//
//  Created by Maros Seleng on 10/01/16.
//  Copyright © 2016 Brightify.org. All rights reserved.
//

import Quick
import SwiftKit

class DictionaryPreferenceDeinitTest: QuickSpec {
    override func spec() {
        describe("DictionaryPreference") {
            let key = "data"
            
            beforeEach {
                TestableDictionaryPreference<NSString, NSString>(key: key).delete()
            }
            
            it("deinit") {
                QuickUtils.assertDeinit { TestableDictionaryPreference<NSString, NSString>(key: key) }
            }
            
            it("deinit if onValueChange is registered") {
                QuickUtils.assertDeinit {
                    let preference = TestableDictionaryPreference<NSString, NSString>(key: key)
                    preference.onValueChange += { _ in
                        
                    }
                    return preference
                }
            }
            
            it("deinit if value exists") {
                QuickUtils.assertDeinit {
                    let preference = TestableDictionaryPreference<NSString, NSString>(key: key)
                    preference.value = ["Hello":"World"]
                    return preference
                }
            }
        }
    }
}

private class TestableDictionaryPreference<K: NSObject, V: AnyObject>: DictionaryPreference<K,V>, Deinitializable {
    let onDeinit = Event<Deinitializable, Void>()
    
    required init(key: String, defaultValue: T = [:]) {
        super.init(key: key, defaultValue: defaultValue)
    }
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
}