//
//  ThreadLocal.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 13/10/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

import Foundation

internal class ThreadLocal<T: AnyObject>: ThreadLocalParametrized<Void, T> {
    
    convenience init(create: () -> T) {
        self.init(id: NSUUID().UUIDString, create: create)
    }
    
    override init(id: String, create: () -> T) {
        super.init(id: id, create: create)
    }
    
    func get() -> T {
        return super.get()
    }
}

internal class ThreadLocalParametrized<PARAMS, T: AnyObject> {
    private let id: String
    private let create: PARAMS -> T
    
    convenience init(create: PARAMS -> T) {
        self.init(id: NSUUID().UUIDString, create: create)
    }
    
    init(id: String, create: PARAMS -> T) {
        self.id = id
        self.create = create
    }
    
    func get(parameters: PARAMS) -> T {
        if let cachedObject = NSThread.currentThread().threadDictionary[id] as? T {
            return cachedObject
        } else {
            let newObject = create(parameters)
            set(newObject)
            return newObject
        }
    }
    
    func set(value: T) {
        NSThread.currentThread().threadDictionary[id] = value
    }
    
    func remove() {
        NSThread.currentThread().threadDictionary.removeObjectForKey(id)
    }
    
}