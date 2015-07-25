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
        Registers a new listener closure with a target object that will be captured as `unowned`, thus not 
        leaking memory. The proper usage would be:
    
          event.registerClosure(self) { target, data in
              target.doSomething()
          }
    
        This is equivalent to:
          event.registerClosure() { [unowned self] data in
              self.doSomething()
          }
        
        :param: target Object that will be captured as `unowned`.
        :param: closure A closure that is called when the event is fired.
    */
    @availability(*, deprecated=0.4.3, message="Capturing something as unowned is dangerous and better to be done visibly when registering the closure.")
    public func registerClosure<T: AnyObject>(target: T, closure: (T, EventData<SENDER, INPUT>) -> ()) {
        registerClosure { [unowned target] data in
            closure(target, data)
        }
    }
    
    /**
        Registers a new listener method.
    
        :param: target The object that the method is declared in.
        :param: method A method that is called when the Event is fired, method has a parameter of type EventData.
    */
    public func registerMethod<T: AnyObject>(target: T, method: (T) -> (EventData<SENDER, INPUT>) -> ()) {
        registerClosure { [weak target] data in
            if let target = target {
                method(target)(data)
            }
        }
    }
    
    /**
        Registers new listener method.
        
        :param: target The object that the method is declared in.
        :param: method A method that is called when the Event is fired, method has no parameters.
    */
    public func registerMethod<T: AnyObject>(target: T, method: (T) -> () -> ()) {
        registerClosure { [weak target] _ in
            if let target = target {
                method(target)()
            }
        }
    }
    
    /// Removes all listeners from the Event instance
    public func clearListeners() {
        listeners.removeAll()
    }
    
}