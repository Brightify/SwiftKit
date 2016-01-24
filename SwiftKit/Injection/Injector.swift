//
//  Module.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import SwiftKitStaging

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
    
    /**
    Returns an implementation binded to type specified by parameter `type`.
    
    - parameter type: The type you want to inject.
    */
    public func get<T>(type: T.Type) -> T {
        do {
            return try getInitializationClosure(type)(self)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
    }
    
    public func get<T: Parametrizable>(type: T.Type, withParameters parameters: T.Parameters) -> T {
        do {
            let closure: (T.Parameters -> T) = try getInitializationClosure(inferredType())(self)
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
    public func get<T>(key: Key<T>) -> T {
        do {
            return try getInitializationClosure(key)(self)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
    }
    
    public func inject<T>(instance: Instance<T>) {
        instance.set(get(T))
    }
    
    public func inject<T>(instance: OptionalInstance<T>) {
        let closure = try? getInitializationClosure(T)
        instance.set(closure?(self))
    }
    
    public func inject<T>(instance: Instance<T>, usingKey key: Key<T>) {
        instance.set(get(key))
    }
    
    public func inject<T>(instance: OptionalInstance<T>, usingKey key: Key<T>) {
        let closure = try? getInitializationClosure(key)
        instance.set(closure?(self))
    }
    
    public func inject<T: Parametrizable>(instance: Instance<T>, withParameters parameters: T.Parameters) {
        instance.set(get(T.self, withParameters: parameters))
    }
    
    public func inject<T: Parametrizable>(instance: OptionalInstance<T>, withParameters parameters: T.Parameters) {
        let closure = try? getInitializationClosure(T)
        instance.set(closure?(self))
    }
    
    public func factory<T>(type: T.Type) -> Factory<T> {
        let initializationClosure: Injector -> T
        do {
            initializationClosure = try getInitializationClosure(type)
        } catch is InjectionError<T> where allowsUnboundFactories {
            initializationClosure = Injector.unboundFactory(type)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
        return Factory<T>(injector: self, closure: initializationClosure)
    }
    
    public func factory<T: Parametrizable>(type: T.Type) -> ParametrizedFactory<T> {
        let initializationClosure: Injector -> T.Parameters -> T
        do {
            initializationClosure = try getInitializationClosure(inferredType())
        } catch is InjectionError<T> where allowsUnboundFactories {
            initializationClosure = Injector.unboundParametrizedFactory(type)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
        return ParametrizedFactory<T>(injector: self, closure: initializationClosure)
    }
    
    public func factory<T: Parametrizable>(type: T.Type, withParameters parameters: T.Parameters) -> Factory<T> {
        let initializationClosure: Injector -> T.Parameters -> T
        do {
            initializationClosure = try getInitializationClosure(inferredType())
        } catch is InjectionError<T> where allowsUnboundFactories {
            initializationClosure = Injector.unboundParametrizedFactory(type)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
        return Factory<T>(injector: self) {
            initializationClosure($0)(parameters)
        }
    }
    
    public func factory<T>(named name: String) -> Factory<T> {
        return factory(Key<T>(named: name))
    }
    
    public func factory<T>(key: Key<T>) -> Factory<T> {
        let initializationClosure: Injector -> T
        do {
            initializationClosure = try getInitializationClosure(key)
        } catch is InjectionError<T> where allowsUnboundFactories {
            initializationClosure = Injector.unboundFactory(T.self)
        } catch let error as InjectionError<T> {
            error.crash()
        } catch let error {
            fatalError("Could not inject because of reasons. \(error)")
        }
        return Factory<T>(injector: self, closure: initializationClosure)
    }
    
    public subscript(index: String) -> KeyedInjector {
        return KeyedInjector(name: index, injector: self)
    }
    
    private func getInitializationClosure<T>(type: T.Type) throws -> Injector -> T {
        let binding = module.bindingForType(type)
        if let injectionClosure = binding?.implementation {
            return injectionClosure
        } else {
            throw InjectionError(binding)
        }
    }
    
    private func getInitializationClosure<T>(key: Key<T>) throws -> Injector -> T {
        let binding = module.bindingForKey(key)
        if let injectionClosure = binding?.implementation {
            return injectionClosure
        } else {
            throw InjectionError(binding)
        }
    }
    
    private func getInitializationClosure<T: ParametrizedInjectable>(type: T.Type) throws -> Injector -> T.Parameters -> T {
        let binding: Binding<T.Parameters -> T>? = module.bindingForType(inferredType())
        if let injectionClosure = binding?.implementation {
            return injectionClosure
        } else {
            throw InjectionError(binding)
        }
    }
    
    private static func unboundParametrizedFactory<T: Parametrizable>(type: T.Type)(injector: Injector)(parameters: T.Parameters) -> T {
        fatalError("Unbound factory of parametrized type \(T.self) cannot be invoked with parameters: \(parameters)")
    }
    
    private static func unboundFactory<T>(type: T.Type)(injector: Injector) -> T {
        fatalError("Unbound factory of type \(T.self) cannot be invoked!")
    }
}