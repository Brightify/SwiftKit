//
//  EventDeinitTest.swift
//  SwiftKit
//
//  Created by Tadeáš Kříž on 5/24/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import XCTest
import SwiftKit

class EventDeinitTest: XCTestCase {
    
    func testDeinit_plainInit_wasCalled() {
        TestUtils.assertDeinit { TestableEvent<EventDeinitTest, Void>() }
    }
    
    func testDeinit_registeredClosure_wasCalled() {
        TestUtils.assertDeinit {
            let event = TestableEvent<EventDeinitTest, Void>()
            event.registerClosure { _ in
                
            }
            return event
        }
    }
    
    func testDeinit_registeredClosureWithTarget_wasCalled() {
        TestUtils.assertDeinit {
            let event = TestableEvent<EventDeinitTest, Void>()
            event.registerClosure(self) { target, _ in
                
            }
            return event
        }
    }
  
    func testDeinit_registeredClosureWithOperator_wasCalled() {
        TestUtils.assertDeinit {
            let event = TestableEvent<EventDeinitTest, Void>()
            event += { _ in
                
            }
            return event
        }
    }
    
    func testDeinit_registeredMethod_wasCalled() {
        TestUtils.assertDeinit {
            let event = TestableEvent<EventDeinitTest, Void>()
            event.registerMethod(self, method: EventDeinitTest.stubMethod)
            return event
        }
    }
    
    func testDeinit_registeredMethodWithEventData_wasCalled() {
        TestUtils.assertDeinit {
            let event = TestableEvent<EventDeinitTest, Void>()
            event.registerMethod(self, method: EventDeinitTest.stubMethodWithEventData)
            return event
        }
    }

    private func stubMethod() {
        
    }
    
    private func stubMethodWithEventData(data: EventData<EventDeinitTest, Void>) {
        
    }
}

private class TestableEvent<SENDER, INPUT>: Event<SENDER, INPUT>, Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}