//
//  Event.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/17/15.
//
//

import Foundation

/**
    Event class is a convenient way to deliver information about an event without using selectors or closures.

    :param: SENDER Type of the owner of this event.
    :param: INPUT Type of the data that will be sent in the event.
*/
public class Event<SENDER, INPUT> {
    
    typealias Listener = (EventData<SENDER, INPUT>) -> ()
    
    private var listeners: [Listener] = []
    
    public init() {
    }
    
    /**
        Invokes all closures registered to this instance.
        
        :param: sender Instance of the owner object.
        :param: input Data that are passed into registered listeners.
    */
    public func fire(sender: SENDER, input: INPUT) {
        let data = EventData(sender: sender, input: input)
        
        fire(data)
    }
    
    /**
        Invokes all closures registered to this instance.
    
        :param: data An EventData structure that is passed to the listeners.
    */
    public func fire(data: EventData<SENDER, INPUT>) {
        for listener in listeners {
            listener(data)
        }
    }
    
    /**
        Registers a new listener closure.
    
        :param: closure A closure that is called when the event is fired.
    */
    public func registerClosure(closure: (EventData<SENDER, INPUT>) -> ()) {
        listeners.append(closure)
    }
    
    /**
        Registers a new listener method.
    
        :param: method A method that is called when the Event is fired, method has a parameter of type EventData.
        :param: owner The object that the method is declared in.
    */
    public func registerMethod<T: AnyObject>(method: T -> (EventData<SENDER, INPUT>) -> (), ownedBy owner: T) {
        registerClosure { [weak owner] data in
            if let owner = owner {
                method(owner)(data)
            }
        }
    }
    
    /**
        Registers new listener method.
        
        :param: target The object that the method is declared in.
        :param: method A method that is called when the Event is fired, method has no parameters.
    */
    public func registerMethod<T: AnyObject>(method: T -> () -> (), ownedBy owner: T) {
        registerClosure { [weak owner] _ in
            if let owner = owner {
                method(owner)()
            }
        }
    }
    
    /// Removes all listeners from the Event instance
    public func clearListeners() {
        listeners.removeAll()
    }
    
    public func relayTo<TRANSFORMED_SENDER, TRANSFORMED_INPUT>(otherEvent: Event<TRANSFORMED_SENDER, TRANSFORMED_INPUT>, transformation: EventData<SENDER, INPUT> -> EventData<TRANSFORMED_SENDER, TRANSFORMED_INPUT>) {
        registerClosure { [weak otherEvent] data in
            otherEvent?.fire(transformation(data))
        }
    }
    
    public func relayTo<TRANSFORMED_INPUT>(otherEvent: Event<SENDER, TRANSFORMED_INPUT>, transformation: INPUT -> TRANSFORMED_INPUT) {
        registerClosure { [weak otherEvent] data in
            otherEvent?.fire(data.sender, input: transformation(data.input))
        }
    }
    
    public func relayTo<NEW_SENDER: AnyObject>(otherEvent: Event<NEW_SENDER, INPUT>, sentBy newSender: NEW_SENDER) {
        registerClosure { [weak otherEvent, weak newSender] data in
            if let newSender = newSender {
                otherEvent?.fire(newSender, input: data.input)
            }
        }
    }
    
    public func relayTo<NEW_SENDER: AnyObject, TRANSFORMED_INPUT>(otherEvent: Event<NEW_SENDER, TRANSFORMED_INPUT>, sentBy newSender: NEW_SENDER, transformation: INPUT -> TRANSFORMED_INPUT) {
        registerClosure { [weak otherEvent, weak newSender] data in
            if let newSender = newSender {
                otherEvent?.fire(newSender, input: transformation(data.input))
            }
        }
    }
    
    public func relayTo<NEW_SENDER: AnyObject, NEW_INPUT>(otherEvent: Event<NEW_SENDER, NEW_INPUT>, sentBy newSender: NEW_SENDER, withInput newInput: NEW_INPUT) {
        registerClosure { [weak otherEvent, weak newSender] _ in
            if let newSender = newSender {
                otherEvent?.fire(newSender, input: newInput)
            }
        }
    }
}