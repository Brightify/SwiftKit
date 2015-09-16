//
//  ModuleBuilder.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import Foundation

/**
    Key is used in Key based injection

    :param: T The parameter is the class type this Key is assigned to
*/
public class Key<T> {
    
    /// Name of the key
    public let name: String

    /**
        Initializes key with name
    
        :param: named The name of the key
    */
    public init(named: String) {
        name = named
    }
}

private func == (lhs: Module.KeyedBindingsMapKey, rhs: Module.KeyedBindingsMapKey) -> Bool {
    return lhs.name == rhs.name && lhs.typeIdentifier == rhs.typeIdentifier
}

/// Module is used to create all bindings in the project
public class Module {
    
    private struct KeyedBindingsMapKey: Hashable {
        let name: String
        let typeIdentifier: ObjectIdentifier
        
        var hashValue: Int {
            return name.hashValue
        }
        
        init<T>(key: Key<T>) {
            name = key.name
            typeIdentifier = ObjectIdentifier(T.self)
        }
    }
    
    /// All bindings with keys
    private var plainBindings: [ObjectIdentifier: AnyObject] = [:]
    // We need to use Int as the key because of the missing generic covariance in Swift. The key's value has to be the Key<T>'s hashValue.
    private var keyedBindings: [KeyedBindingsMapKey: AnyObject] = [:] // [Key<Any>: AnyObject] = [:]
    
    public var allowUnboundFactories: Bool = false
    
    public init() {
        
    }
    
    public func configure() {
    }
    
    public func bind<T>(type: T.Type) -> ClosureBindingBuilder<T> {
        return ClosureBindingBuilder(binding: createTypeBinding(type))
    }
    
    public func bind<T: protocol<AnyObject, Injectable>>(type: T.Type) -> BindingBuilder<T> {
        return BindingBuilder(binding: createTypeBinding(type))
    }
    
    public func bind<T: protocol<AnyObject, PostInitInjectable>>(type: T.Type) -> PostInitInjectableBindingBuilder<T> {
        return PostInitInjectableBindingBuilder(binding: createTypeBinding(type))
    }
    
    public func bindKey<T>(key: Key<T>) -> ClosureBindingBuilder<T> {
        return ClosureBindingBuilder(binding: createKeyBinding(key))
    }
    
    public func bindKey<T: protocol<AnyObject, Injectable>>(key: Key<T>) -> BindingBuilder<T> {
        return BindingBuilder(binding: createKeyBinding(key))
    }
    
    public func bindKey<T: protocol<AnyObject, PostInitInjectable>>(key: Key<T>) -> PostInitInjectableBindingBuilder<T> {
        return PostInitInjectableBindingBuilder(binding: createKeyBinding(key))
    }
    
    func bindingForType<T>(type: T.Type) -> Binding<T>? {
        return plainBindings[ObjectIdentifier(type)] as? Binding<T>
    }
    
    func bindingForKey<T>(key: Key<T>) -> Binding<T>? {
        let bindingKey = KeyedBindingsMapKey(key: key)
        return keyedBindings[bindingKey] as? Binding<T>
    }
    
    private func createTypeBinding<T>(type: T.Type) -> Binding<T> {
        let binding: Binding = Binding<T>(type: type)
        plainBindings[ObjectIdentifier(type)] = binding
        return binding
    }
    
    private func createKeyBinding<T>(key: Key<T>) -> Binding<T> {
        let bindingKey = KeyedBindingsMapKey(key: key)
        let binding = Binding<T>(type: T.self)
        keyedBindings[bindingKey] = binding
        return binding
    }

}

public class BindingBuilder<T: protocol<AnyObject, Injectable>> {
    
    private var binding: Binding<T>

    private init(binding: Binding<T>) {
        self.binding = binding
        
        // We use the same type as a default implementation.
        to(T)
    }

    public func to(implementation: T.Type) -> SingletonBinder<T> {
        binding.implementation = { injector in
            implementation.init(injector: injector)
        }
        
        return SingletonBinder<T>(binding: binding)
    }
    
    public func asSingleton() {
        SingletonBinder(binding: binding).asSingleton()
    }
}

public class PostInitInjectableBindingBuilder<T: protocol<AnyObject, PostInitInjectable>> {
    private var binding: Binding<T>
    
    private init(binding: Binding<T>) {
        self.binding = binding
        
        // We use the same type as a default implementation.
        to(T)
    }
    
    public func to(implementation: T.Type) -> SingletonBinder<T> {
        binding.implementation = { injector in
            let injectable = implementation.init()
            injectable.inject(injector)
            return injectable
        }
        
        return SingletonBinder(binding: binding)
    }
    
    public func asSingleton() {
        SingletonBinder(binding: binding).asSingleton()
    }
}

public class ClosureBindingBuilder<T> {
    
    private var binding: Binding<T>
    
    private init(binding: Binding<T>) {
        self.binding = binding
        
        binding.implementation = { _ in
            // We need to use `assert(false, ...)` because if `fatalError` is used, we get a warning on the return line.
            assert(false, "Implementation type was not set! You need to call method 'to' or 'toNew' if the binded type is not Injectable or PostInitInjectable!")
            // Without this line the compiler thinks this closure is not (Injector -> T) and does not compile.
            return nil as T!
        }
    }
    
    public func to(closure: (injector: Injector) -> T) -> SingletonBinder<T> {
        binding.implementation = { injector in
            closure(injector: injector)
        }
        
        return SingletonBinder(binding: binding)
    }
    
    public func toNew(@autoclosure(escaping) closure: () -> T) -> SingletonBinder<T> {
        return to { _ in
            closure()
        }
    }
}

public class SingletonBinder<T> {
    private var binding: Binding<T>
    
    private init(binding: Binding<T>) {
        self.binding = binding
    }
    
    public func asSingleton() {
        let implementation = binding.implementation
        var singleton: T? = nil
        binding.implementation = { injector in
            if singleton == nil {
                singleton = implementation?(injector)
            }
            
            if let singleton = singleton {
                return singleton
            } else {
                fatalError("Could not instantiate the singleton of type \(T.self)!")
            }
        }
    }
}

// FIXME It seems like the Binding can't be access from outside, but yet is public. Also the name and type is not used.
public class Binding<T> {

    public private(set) var type: T.Type
    public private(set) var implementation: (Injector -> T)?
    
    private init(type: T.Type) {
        self.type = type
    }

}