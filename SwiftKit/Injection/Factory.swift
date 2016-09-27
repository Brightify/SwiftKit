//
//  Factory.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

open class Factory<T> {
    
    let factoryClosure: () -> T
    
    init(closure: @escaping () -> T) {
        factoryClosure = closure
    }
    
    init(injector: Injector, closure: @escaping (Injector) -> T) {
        factoryClosure = {
            closure(injector)
        }
    }
    
    open func create() -> T {
        return factoryClosure()
    }
    
}
