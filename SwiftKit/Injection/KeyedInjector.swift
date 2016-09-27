//
//  KeyedInjector.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/19/15.
//
//

open class KeyedInjector {
    
    let name: String
    let injector: Injector
    
    init(name: String, injector: Injector) {
        self.name = name
        self.injector = injector
    }
    
    open func get<T>(_ type: T.Type) -> T {
        return injector.get(Key<T>(named: name))
    }
    
    open func inject<T>(_ instance: Instance<T>) {
        injector.inject(instance, usingKey: Key<T>(named: name))
    }
    
    open func factory<T>(_ type: T.Type) -> Factory<T> {
        return injector.factory(Key<T>(named: name))
    }
    
}
