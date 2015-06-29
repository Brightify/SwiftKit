//
//  EventTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 28.06.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import XCTest
import SwiftKit

class EventTest: XCTestCase {
    
    func testFire_registeredListenerByOperator_callListener() {
        assertFireEvent { event, listener in
            event += listener
        }
    }

    func testFire_registerClosure_callListener() {
        assertFireEvent { event, listener in
            event.registerClosure(listener)
        }
    }
    
    func testFire_registerClosureWithTarget_callListener() {
        assertFireEvent { event, listener in
            event.registerClosure(self) { _, data in
                listener(data: data)
            }
        }
    }
    
    private func assertFireEvent(@noescape registerListener: (event: Event<EventTest, Void>,
        listener: (data: EventData<EventTest, Void>) -> ()) -> ()) {
        let event = Event<EventTest, Void>()
        var timesFired = 0
        registerListener(event: event) { _ in
            timesFired++
        }
        
        event.fire(self, input: Void())
        
        XCTAssertEqual(timesFired, 1)
    }
    
}

class EventTestCorrectInput: XCTestCase {
    
    func testFire_registeredListenerByOperator_callListenerWithCorrectInput() {
        assertFireEventWithCorrectInput { event, listener in
            event += listener
        }
    }
    
    func testFire_registerClosure_callListenerWithCorrectInput() {
        assertFireEventWithCorrectInput { event, listener in
            event.registerClosure(listener)
        }
    }
    
    func testFire_registerClosureWithTarget_callListener() {
        assertFireEventWithCorrectInput { event, listener in
            event.registerClosure(self) { _, data in
                listener(data: data)
            }
        }
    }
    
    private func assertFireEventWithCorrectInput(@noescape registerListener: (event: Event<EventTestCorrectInput, Int>,
        listener: (data: EventData<EventTestCorrectInput, Int>) -> ()) -> ()) {
            let event = Event<EventTestCorrectInput, Int>()
            let input = 10
            var passedInput: Int?
            registerListener(event: event) { data in
                passedInput = data.input
            }
            
            event.fire(self, input: input)
            
            XCTAssertNotNil(passedInput)
            if let passedInput = passedInput {
                XCTAssertEqual(passedInput, input)
            }
    }
}

class EventTestCorrectSender: XCTestCase {
    
    func testFire_registeredListenerByOperator_callListenerWithCorrectSender() {
        assertFireEventWithCorrectSender { event, listener in
            event += listener
        }
    }
    
    func testFire_registerClosure_callListenerWithCorrectSender() {
        assertFireEventWithCorrectSender { event, listener in
            event.registerClosure(listener)
        }
    }
    
    func testFire_registerClosureWithTarget_callListener() {
        assertFireEventWithCorrectSender { event, listener in
            event.registerClosure(self) { _, data in
                listener(data: data)
            }
        }
    }
    
    private func assertFireEventWithCorrectSender(@noescape registerListener: (event: Event<EventTestCorrectSender, Void>,
        listener: (data: EventData<EventTestCorrectSender, Void>) -> ()) -> ()) {
            let event = Event<EventTestCorrectSender, Void>()
            var passedSender: EventTestCorrectSender?
            registerListener(event: event) { data in
                passedSender = data.sender
            }
            
            event.fire(self, input: Void())
            
            XCTAssertNotNil(passedSender)
            if let passedSender = passedSender {
                XCTAssertTrue(self === passedSender, "Sender is not correct.")
            }
    }
}

class EventTestMethodRegistration: XCTestCase {
    
    var wasMethodCalled = false
    
    override func setUp() {
        wasMethodCalled = false
    }
    
    func testFire_registeredMethod_callListener() {
        let event = Event<EventTestMethodRegistration, Void>()
        event.registerMethod(self, method: EventTestMethodRegistration.stubMethod)
        
        event.fire(self, input: Void())
        
        XCTAssertTrue(wasMethodCalled)
    }
    
    func testFire_registeredMethodWithEventData_callListener() {
        let event = Event<EventTestMethodRegistration, Void>()
        event.registerMethod(self, method: EventTestMethodRegistration.stubMethodWithEventData)
        
        event.fire(self, input: Void())
        
        XCTAssertTrue(wasMethodCalled)
    }
    
    private func stubMethod() {
        wasMethodCalled = true
    }
    
    private func stubMethodWithEventData(data: EventData<EventTestMethodRegistration, Void>) {
        wasMethodCalled = true
    }
}

class EventTestMethodRegistrationCorrectInput: XCTestCase {
    
    let input = 10
    
    var passedInput: Int?
    
    override func setUp() {
        passedInput = nil
    }
    
    func testFire_registeredMethod_callListener() {
        let event = Event<EventTestMethodRegistrationCorrectInput, Int>()
        event.registerMethod(self, method: EventTestMethodRegistrationCorrectInput.stubMethod)
        
        event.fire(self, input: input)
        
        XCTAssertNotNil(passedInput)
        if let passedInput = passedInput {
            XCTAssertEqual(passedInput, input)
        }
    }
    
    private func stubMethod(data: EventData<EventTestMethodRegistrationCorrectInput, Int>) {
        passedInput = data.input
    }
}

class EventTestMethodRegistrationCorrectSender: XCTestCase {
    
    var passedSender: EventTestMethodRegistrationCorrectSender?
    
    override func setUp() {
        passedSender = nil
    }
    
    func testFire_registeredMethod_callListener() {
        let event = Event<EventTestMethodRegistrationCorrectSender, Void>()
        event.registerMethod(self, method: EventTestMethodRegistrationCorrectSender.stubMethod)
        
        event.fire(self, input: Void())
        
        XCTAssertNotNil(passedSender)
        if let passedSender = passedSender {
            XCTAssertTrue(self === passedSender, "Sender is not correct.")
        }
    }
    
    private func stubMethod(data: EventData<EventTestMethodRegistrationCorrectSender, Void>) {
        passedSender = data.sender
    }
}
