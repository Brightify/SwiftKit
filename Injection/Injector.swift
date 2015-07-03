//
//  Module.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import Foundation

public class Injector {
    
    let module: Module
    
    public class func createInjector(module: Module) -> Injector {
        module.configure()
        let injector = Injector(module: module)
        return injector
    }
    
    private init(module: Module) {
        self.module = module
    }
    
    public func get<T>() -> T {
        return get(T.self)
    }
    
    public func get<T>(type: T.Type) -> T {
        return getInitializationClosure(type)(self)
    }
    
    public func get<T>(named name: String) -> T {
        return get(Key<T>(named: name))
    }
    
    public func get<T>(key: Key<T>) -> T {
        return getInitializationClosure(key)(self)
    }
    
    public func factory<T>() -> Factory<T> {
        return factory(T.self)
    }
    
    public func factory<T>(type: T.Type) -> Factory<T> {
        let initializationClosure = getInitializationClosure(type)
        return Factory<T>(injector: self, closure: initializationClosure)
    }
    
    public func factory<T>(named name: String) -> Factory<T> {
        return factory(Key<T>(named: name))
    }
    
    public func factory<T>(key: Key<T>) -> Factory<T> {
        let initializationClosure = getInitializationClosure(key)
        return Factory<T>(injector: self, closure: initializationClosure)
    }
    
    public subscript(index: String) -> KeyedInjector {
        return KeyedInjector(name: index, injector: self)
    }
    
    private func getInitializationClosure<T>(type: T.Type) -> Injector -> T {
        let binding = module.bindingForType(type)
        if let injectionClosure = binding?.implementation {
            return injectionClosure
        } else {
            fatalError("Binding for type \(type) was \(binding)")
        }
    }
    
    private func getInitializationClosure<T>(key: Key<T>) -> Injector -> T {
        let binding = module.bindingForKey(key)
        if let injectionClosure = binding?.implementation {
            return injectionClosure
        } else {
            fatalError("Binding for key \(key) was \(binding) with implementation \(binding?.implementation)")
        }
    }
}