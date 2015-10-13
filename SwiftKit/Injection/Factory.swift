//
//  Factory.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

public class Factory<T> {
    
    let factoryClosure: () -> T
    
    init(closure: () -> T) {
        factoryClosure = closure
    }
    
    init(injector: Injector, closure: Injector -> T) {
        factoryClosure = {
            closure(injector)
        }
    }
    
    public func create() -> T {
        return factoryClosure()
    }
    
}