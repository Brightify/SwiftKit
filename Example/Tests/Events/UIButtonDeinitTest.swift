//
//  UIButtonDeinitTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 28.06.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//


import XCTest
import SwiftKit

class UIButtonDeinitTest: XCTestCase {
    
    func testDeinit_plainInit_wasCalled() {
        TestUtils.assertDeinit { TestableUIButton() }
    }
    
    func testDeinit_registeredTouchDown_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.touchDown += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredTouchDownRepeat_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.touchDownRepeat += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredTouchDragInside_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.touchDragInside += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredTouchDragOutside_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.touchDragOutside += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredTouchDragEnter_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.touchDragEnter += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredTouchDragExit_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.touchDragExit += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredTouchUpInside_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.touchUpInside += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredTouchUpOutside_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.touchUpOutside += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredValueChanged_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.valueChanged += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredEditingDidBegin_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.editingDidBegin += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredEditingChanged_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.editingChanged += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredEditingDidEnd_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.editingDidEnd += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredEditingDidEndOnExit_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.editingDidEndOnExit += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredAllTouchEvents_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.allTouchEvents += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredAllEditingEvents_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.allEditingEvents += { _ in
                
            }
            return button
        }
    }
    
    func testDeinit_registeredAllEvents_wasCalled() {
        TestUtils.assertDeinit {
            let button = TestableUIButton()
            button.allEvents += { _ in
                
            }
            return button
        }
    }
    
}

private class TestableUIButton: UIButton, Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}