//
//  Module.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import SwiftKitStaging

open class Injector {
    
    fileprivate let module: Module
    fileprivate let allowsUnboundFactories: Bool
    
    /**
    Creates an injector with a specified module.
    */
    open class func createInjector(_ module: Module) -> Injector {
        module.configure()
        let injector = Injector(module: module)
        return injector
    }
    
    fileprivate init(module: Module) {
        self.module = module
        self.allowsUnboundFactories = module.allowUnboundFactories
    }
    
    /**
    Returns an implementation binded to type specified by parameter `type`.
    
    - parameter type: The type you want to inject.
    */
    open func get<T>(_ type: T.Type) -> T {
        do {
            return try getInitializationClosure(type)(self)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
    }
    
    open func get<T: Parametrizable>(_ type: T.Type, withParameters parameters: T.Parameters) -> T {
        do {
            let closure: ((T.Parameters) -> T) = try getInitializationClosure(inferredType())(self)
            return closure(parameters)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
    }
    
    /**
    Returns an implementation binded to the specified key.
        
    - parameter key: A key used to retrieve the binded type.
    */
    open func get<T>(_ key: Key<T>) -> T {
        do {
            return try getInitializationClosure(key)(self)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
    }
    
    open func inject<T>(_ instance: Instance<T>) {
        instance.set(get(T.self))
    }
    
    open func inject<T>(_ instance: OptionalInstance<T>) {
        let closure = try? getInitializationClosure(T.self)
        instance.set(closure?(self))
    }
    
    open func inject<T>(_ instance: Instance<T>, usingKey key: Key<T>) {
        instance.set(get(key))
    }
    
    open func inject<T>(_ instance: OptionalInstance<T>, usingKey key: Key<T>) {
        let closure = try? getInitializationClosure(key)
        instance.set(closure?(self))
    }
    
    open func inject<T: Parametrizable>(_ instance: Instance<T>, withParameters parameters: T.Parameters) {
        instance.set(get(T.self, withParameters: parameters))
    }
    
    open func inject<T: Parametrizable>(_ instance: OptionalInstance<T>, withParameters parameters: T.Parameters) {
        let closure = try? getInitializationClosure(T.self)
        instance.set(closure?(self))
    }
    
    open func factory<T>(_ type: T.Type) -> Factory<T> {
        let initializationClosure: (Injector) -> T
        do {
            initializationClosure = try getInitializationClosure(type)
        } catch is InjectionError<T> where allowsUnboundFactories {
            initializationClosure = Injector.unboundFactory(for: type)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
        return Factory<T>(injector: self, closure: initializationClosure)
    }
    
    open func factory<T: Parametrizable>(_ type: T.Type) -> ParametrizedFactory<T> {
        let initializationClosure: (Injector) -> (T.Parameters) -> T
        do {
            initializationClosure = try getInitializationClosure(inferredType())
        } catch is InjectionError<T> where allowsUnboundFactories {
            initializationClosure = Injector.unboundParametrizedFactory(for: type)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
        return ParametrizedFactory<T>(injector: self, closure: initializationClosure)
    }
    
    open func factory<T: Parametrizable>(_ type: T.Type, withParameters parameters: T.Parameters) -> Factory<T> {
        let initializationClosure: (Injector) -> (T.Parameters) -> T
        do {
            initializationClosure = try getInitializationClosure(inferredType())
        } catch is InjectionError<T> where allowsUnboundFactories {
            initializationClosure = Injector.unboundParametrizedFactory(for: type)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
        return Factory<T>(injector: self) {
            initializationClosure($0)(parameters)
        }
    }
    
    open func factory<T>(named name: String) -> Factory<T> {
        return factory(Key<T>(named: name))
    }
    
    open func factory<T>(_ key: Key<T>) -> Factory<T> {
        let initializationClosure: (Injector) -> T
        do {
            initializationClosure = try getInitializationClosure(key)
        } catch is InjectionError<T> where allowsUnboundFactories {
            initializationClosure = Injector.unboundFactory(for: T.self)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
        return Factory<T>(injector: self, closure: initializationClosure)
    }
    
    open subscript(index: String) -> KeyedInjector {
        return KeyedInjector(name: index, injector: self)
    }
    
    fileprivate func getInitializationClosure<T>(_ type: T.Type) throws -> (Injector) -> T {
        let binding = module.bindingForType(type)
        if let injectionClosure = binding?.implementation {
            return injectionClosure
        } else {
            throw InjectionError(binding)
        }
    }
    
    fileprivate func getInitializationClosure<T>(_ key: Key<T>) throws -> (Injector) -> T {
        let binding = module.bindingForKey(key)
        if let injectionClosure = binding?.implementation {
            return injectionClosure
        } else {
            throw InjectionError(binding)
        }
    }
    
    fileprivate func getInitializationClosure<T: ParametrizedInjectable>(_ type: T.Type) throws -> (Injector) -> (T.Parameters) -> T {
        let binding: Binding<(T.Parameters) -> T>? = module.bindingForType(inferredType())
        if let injectionClosure = binding?.implementation {
            return injectionClosure
        } else {
            throw InjectionError(binding)
        }
    }
    
    fileprivate static func unboundParametrizedFactory<T: Parametrizable>(for type: T.Type) -> (Injector) -> (T.Parameters) -> T {
        return { _ in
            return { parameters in
                fatalError("Unbound factory of parametrized type \(T.self) cannot be invoked with parameters: \(parameters)") as! T
            }
        }
    }
    
    fileprivate static func unboundFactory<T>(for type: T.Type) -> (Injector) -> T {
        return { _ in fatalError("Unbound factory of type \(T.self) cannot be invoked!") as! T }
    }
}
