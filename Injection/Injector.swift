//
//  Module.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import Foundation

public class Injector {
    
    private let module: Module
    private let allowsUnboundFactories: Bool
    
    /**
        Creates an injector with a specified module.
    */
    public class func createInjector(module: Module) -> Injector {
        module.configure()
        let injector = Injector(module: module)
        return injector
    }
    
    private init(module: Module) {
        self.module = module
        self.allowsUnboundFactories = module.allowUnboundFactories
    }
    
    /// Returns an implementation binded to type `T` which is resolved from the callsite.
    public func get<T>() -> T {
        return get(T.self)
    }
    
    /**
        Returns an implementation binded to type specified by parameter `type`.
    
        :param: type The type you want to inject.
    */
    public func get<T>(type: T.Type) -> T {
        return getInitializationClosure(type)(self)
    }
    
    /** 
        Returns an implementation binded to type `T` which is resolved from the callsite and the key name.

        :param: named A name of the binding key.
    */
    public func get<T>(named name: String) -> T {
        return get(Key<T>(named: name))
    }
    
    /** 
        Returns an implementation binded to the specified key.
        
        :param: key A key used to retrieve the binded type.
    */
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
        } else if allowsUnboundFactories {
            return Injector.unboundFactory
        } else {
            fatalError("Binding for type \(type) was \(binding)")
        }
    }
    
    private func getInitializationClosure<T>(key: Key<T>) -> Injector -> T {
        let binding = module.bindingForKey(key)
        if let injectionClosure = binding?.implementation {
            return injectionClosure
        } else if allowsUnboundFactories {
            return Injector.unboundFactory
        } else {
            fatalError("Binding for key \(key) was \(binding) with implementation \(binding?.implementation)")
        }
    }
    
    private static func unboundFactory<T>(injector: Injector) -> T {
        fatalError("Unbound factory of type \(T.self) cannot be invoked!")
    }
}