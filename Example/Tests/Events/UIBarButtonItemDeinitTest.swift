//
//  UIBarButtonItemDeinitTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 28.06.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//


import XCTest
import SwiftKit

class UIBarButtonItemDeinitTest: XCTestCase {
    
    func testDeinit_plainInit_wasCalled() {
        TestUtils.assertDeinit { TestableUIBarButtonItem(title: "", style: .Plain) }
    }
    
    func testDeinit_registeredTouchUpInside_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIBarButtonItem(title: "", style: .Plain)
            button.selected += { _ in
                
            }
            return button
        }
    }
    
}

private class TestableUIBarButtonItem: UIBarButtonItem, Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}