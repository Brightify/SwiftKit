//
//  Operators.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/17/15.
//
//

import Foundation

infix operator ~> {  }


/// Operator that wraps method to closure with handled memory management
public func ~> <T: AnyObject, SENDER, IN>(target: T, method: (T) -> (EventData<SENDER, IN>) -> ()) -> (EventData<SENDER, IN>) -> () {
    return { [weak target] (data: EventData<SENDER, IN>) in
        if let target = target {
            method(target)(data)
        }
    }
}

/// Operator that registers closure to Event
public func += <SENDER, IN>(event: Event<SENDER, IN>, listener: (EventData<SENDER, IN>) -> ()) {
    event.registerClosure(listener)
}