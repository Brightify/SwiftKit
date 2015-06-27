//
//  Event.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/17/15.
//
//

import Foundation

/**
* Event submodule contains implementation of listeners using closures
*/
public class Event<SENDER, INPUT> {
    
    typealias Listener = (EventData<SENDER, INPUT>) -> ()
    
    private var listeners: [Listener] = []
    
    public init() {
    }
    
    /**
    * Invokes all closures registered in this Event
    * :param: sender The object that invokes the closure
    * :param: input The data that are passed back through the listener from the sender object
    */
    public func fire(sender: SENDER, input: INPUT) {
        let data = EventData(sender: sender, input: input)
        
        fire(data)
    }
    
    /**
    * Invokes all closures registered in this Event
    * :param: data The data structure that is passed to the listeners
    */
    public func fire(data: EventData<SENDER, INPUT>) {
        for listener in listeners {
            listener(data)
        }
    }
    
    /**
    * Registers new closure
    * :param: The closure that is called when the Event is fired
    */
    public func registerClosure(closure: (EventData<SENDER, INPUT>) -> ()) {
        listeners.append(closure)
    }
    
    /**
    * Registers new closure with target handling for proper memory management
    * :param: target The object that registers the closure
    * :param: The closure that is called when the Event is fired
    */
    public func registerClosure<T: AnyObject>(target: T, closure: (T, EventData<SENDER, INPUT>) -> ()) {
        registerClosure { [unowned target] data in
            closure(target, data)
        }
    }
    
    /**
    * Registers new method
    * :param: The object that registers the closure
    * :param: The method that is called when the Event is fired, method has a parameter of type EventData
    */
    public func registerMethod<T: AnyObject>(target: T, method: (T) -> (EventData<SENDER, INPUT>) -> ()) {
        registerClosure { [unowned target] data in
            method(target)(data)
        }
    }
    
    /**
    * Registers new method
    * :param: The object that registers the closure
    * :param: The method that is called when the Event is fired, method has a parameter of type EventData
    */
    public func registerMethod<T: AnyObject>(target: T, method: (T) -> () -> ()) {
        registerClosure { [unowned target] _ in
            method(target)()
        }
    }
    
    /**
    * Removes all listeners from the Event
    */
    public func clearListeners() {
        listeners.removeAll()
    }
    
}