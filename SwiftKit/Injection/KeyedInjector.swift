//
//  KeyedInjector.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/19/15.
//
//

public class KeyedInjector {
    
    let name: String
    let injector: Injector
    
    init(name: String, injector: Injector) {
        self.name = name
        self.injector = injector
    }
    
    public func get<T>(type: T.Type) -> T {
        return injector.get(Key<T>(named: name))
    }
    
    public func inject<T>(instance: Instance<T>) {
        injector.inject(instance, usingKey: Key<T>(named: name))
    }
    
    public func factory<T>(type: T.Type) -> Factory<T> {
        return injector.factory(Key<T>(named: name))
    }
    
}