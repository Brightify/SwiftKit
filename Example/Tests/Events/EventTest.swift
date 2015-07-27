//
//  EventTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 02.07.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class EventTest: QuickSpec {
    
    var wasMethodCalled = false
    var passedSender: EventTest?
    var passedInput: Int?
    
    override func spec() {
        describe("Event") {
            context("listener registered with operator") {
                it("fires event") {
                    self.assertEventFired { event, listener in
                        event += listener
                    }
                }
                
                it("fires event with correct input") {
                    self.assertEventFiredWithCorrectInput { event, listener in
                        event += listener
                    }
                }
                
                it("fires event with correct sender") {
                    self.assertEventFiredWithCorrectSender { event, listener in
                        event += listener
                    }
                }
            }
            
            context("listener registered as closure") {
                it("fires event") {
                    self.assertEventFired { event, listener in
                        event.registerClosure(listener)
                    }
                }
                
                it("fires event with correct input") {
                    self.assertEventFiredWithCorrectInput { event, listener in
                        event.registerClosure(listener)
                    }
                }
                
                it("fires event with correct sender") {
                    self.assertEventFiredWithCorrectSender { event, listener in
                        event.registerClosure(listener)
                    }
                }
            }
            
            context("listener registered as method") {
                beforeEach {
                    self.wasMethodCalled = false
                    self.passedSender = nil
                    self.passedInput = nil
                }
                
                it("fires event") {
                    let event = Event<EventTest, Void>()
                    event.registerMethod(EventTest.stubMethod, ownedBy: self)
                    
                    event.fire(self, input: Void())
                    
                    expect(self.wasMethodCalled) == true
                }
                
                it("fires event with correct input") {
                    let event = Event<EventTest, Int>()
                    event.registerMethod(EventTest.stubMethodWithInput, ownedBy: self)
                    let input = 10
                    
                    event.fire(self, input: input)
                    
                    expect(self.passedInput) == input
                }
                
                it("fires event with correct sender") {
                    let event = Event<EventTest, Void>()
                    event.registerMethod(EventTest.stubMethodWithSender, ownedBy: self)
                    
                    event.fire(self, input: Void())
                    
                    expect(self.passedSender) === self
                }
            }
        }
    }
    
    private func assertEventFired(@noescape registerListener: (event: Event<EventTest, Void>,
        listener: (data: EventData<EventTest, Void>) -> ()) -> ()) {
            let event = Event<EventTest, Void>()
            var timesFired = 0
            registerListener(event: event) { _ in
                timesFired++
            }
            
            event.fire(self, input: Void())
            
            expect(timesFired) == 1
    }
    
    private func assertEventFiredWithCorrectInput(@noescape registerListener: (event: Event<EventTest, Int>,
        listener: (data: EventData<EventTest, Int>) -> ()) -> ()) {
            let event = Event<EventTest, Int>()
            let input = 10
            var passedInput: Int?
            registerListener(event: event) { data in
                passedInput = data.input
            }
            
            event.fire(self, input: input)
            
            expect(passedInput) == input
    }
    
    private func assertEventFiredWithCorrectSender(@noescape registerListener: (event: Event<EventTest, Void>,
        listener: (data: EventData<EventTest, Void>) -> ()) -> ()) {
            let event = Event<EventTest, Void>()
            var passedSender: EventTest?
            registerListener(event: event) { data in
                passedSender = data.sender
            }
            
            event.fire(self, input: Void())
            
            expect(passedSender) === self
    }
    
    private func stubMethod() {
        wasMethodCalled = true
    }
    
    private func stubMethodWithInput(data: EventData<EventTest, Int>) {
        passedInput = data.input
    }
    
    private func stubMethodWithSender(data: EventData<EventTest, Void>) {
        passedSender = data.sender
    }
}