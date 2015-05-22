//
//  Event.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/17/15.
//
//

import Foundation

public class Event<SENDER: AnyObject, INPUT> {
    
    typealias Listener = (EventData<SENDER, INPUT>) -> ()
    
    private var listeners: [Listener] = []
    
    public init() {
    }
    
    public func fire(sender: SENDER, input: INPUT) {
        let data = EventData(sender: sender, input: input)
        
        fire(data)
    }
    
    public func fire(data: EventData<SENDER, INPUT>) {
        for listener in listeners {
            listener(data)
        }
    }
    
    public func registerClosure(closure: (EventData<SENDER, INPUT>) -> ()) {
        listeners.append(closure)
    }
    
    public func registerClosure<T: AnyObject>(target: T, closure: (T, EventData<SENDER, INPUT>) -> ()) {
        registerClosure { [unowned target] data in
            closure(target, data)
        }
    }
    
    public func registerMethod<T: AnyObject>(target: T, method: (T) -> (EventData<SENDER, INPUT>) -> ()) {
        registerClosure { [unowned target] data in
            method(target)(data)
        }
    }
    
    public func registerMethod<T: AnyObject>(target: T, method: (T) -> () -> ()) {
        registerClosure { [unowned target] _ in
            method(target)()
        }
    }
    
    public func clearEvents() {
        listeners.removeAll()
    }
    
}