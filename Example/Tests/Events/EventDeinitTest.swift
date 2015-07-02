//
//  EventDeinitTest.swift
//  SwiftKit
//
//  Created by Tadeáš Kříž on 5/24/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import SwiftKit

class EventDeinitTest: QuickSpec {
    
    override func spec() {
        describe("Event") {
            it("deinit") {
                TestUtils.assertDeinit { TestableEvent<EventDeinitTest, Void>() }
            }
            
            it("deinit if closure is registered") {
                TestUtils.assertDeinit {
                    let event = TestableEvent<EventDeinitTest, Void>()
                    event.registerClosure { _ in
                        
                    }
                    return event
                }
            }
            
            it("deinit if closure is registered with target") {
                TestUtils.assertDeinit {
                    let event = TestableEvent<EventDeinitTest, Void>()
                    event.registerClosure(self) { target, _ in
                        
                    }
                    return event
                }
            }
            
            it("deinit if closure is registered with operator") {
                TestUtils.assertDeinit {
                    let event = TestableEvent<EventDeinitTest, Void>()
                    event += { _ in
                        
                    }
                    return event
                }
            }
            
            it("deinit if method is registered") {
                TestUtils.assertDeinit {
                    let event = TestableEvent<EventDeinitTest, Void>()
                    event.registerMethod(self, method: EventDeinitTest.stubMethod)
                    return event
                }
            }
            
            it("deinit if method with EventData is registered") {
                TestUtils.assertDeinit {
                    let event = TestableEvent<EventDeinitTest, Void>()
                    event.registerMethod(self, method: EventDeinitTest.stubMethodWithEventData)
                    return event
                }
            }
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