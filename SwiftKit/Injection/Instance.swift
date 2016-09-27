//
//  Instance.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 11/10/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

open class Instance<T> {
    var instance: T?
    
    public init() { }
    
    open func get() -> T {
        guard let instance = instance else { fatalError("Instance of type \(T.self) is not set.") }
        return instance
    }
    
    internal func set(_ instance: T) {
        self.instance = instance
    }
}
