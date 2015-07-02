//
//  UIBarButtonItemDeinitTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 28.06.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import SwiftKit

class UIBarButtonItemDeinitTest: QuickSpec {
    
    override func spec() {
        describe("UIBarButtonItem") {
            it("deinit") {
                TestUtils.assertDeinit { TestableUIBarButtonItem(title: "", style: .Plain) }
            }
            
            it("deinit if selected is registered") {
                TestUtils.assertDeinit {
                    let button = TestableUIBarButtonItem(title: "", style: .Plain)
                    button.selected += { _ in
                        
                    }
                    return button
                }
            }
        }
    }
    
}

private class TestableUIBarButtonItem: UIBarButtonItem, Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}