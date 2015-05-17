//
//  Operators.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/17/15.
//
//

import Foundation

infix operator ~> {  }

public func ~> <T: AnyObject, SENDER, IN>(target: T, method: (T) -> (EventData<SENDER, IN>) -> ()) -> (EventData<SENDER, IN>) -> () {
    return { [unowned target] (data: EventData<SENDER, IN>) in
        method(target)(data)
    }
}

public func ~> <T: AnyObject, SENDER, IN>(target: T, closure: (T, EventData<SENDER, IN>) -> ()) -> (EventData<SENDER, IN>) -> () {
    return { [unowned target] (data: EventData<SENDER, IN>) in
        closure(target, data)
    }
}

public func += <SENDER, IN>(event: Event<SENDER, IN>, listener: (EventData<SENDER, IN>) -> ()) {
    event.registerClosure(listener)
}

public func += <SENDER, IN>(event: Event<SENDER, IN>, listener: () -> ()) {
    event.registerClosure(listener)
}