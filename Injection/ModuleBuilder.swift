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

/// Module is used to create all bindings in the project
public class Module {
    
    /// All bindings with keys
    public private(set) var bindings: [String: AnyObject] = [:]
    
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
        let typeName = stringFromType(type)
        return bindings[typeName] as? Binding<T>
    }
    
    func bindingForKey<T>(key: Key<T>) -> Binding<T>? {
        let bindingName = bindingNameForKey(key)
        return bindings[bindingName] as? Binding<T>
    }
    
    private func createTypeBinding<T>(type: T.Type) -> Binding<T> {
        let typeName = stringFromType(type)
        let binding: Binding = Binding<T>(name: typeName, type: type)
        bindings[typeName] = binding
        return binding
    }
    
    private func createKeyBinding<T>(key: Key<T>) -> Binding<T> {
        let bindingName = bindingNameForKey(key)
        let binding = Binding<T>(name: bindingName, type: T.self)
        bindings[bindingName] = binding
        return binding
    }
    
    private func bindingNameForKey<T>(key: Key<T>) -> String {
        let typeName = stringFromType(T.self)
        return "Key: \(key.name), \(typeName)"
    }
    
    private func stringFromType<T>(type: T.Type) -> String {
        if let classType: AnyClass = type as? AnyClass {
            return "Class: \(NSStringFromClass(classType))"
        } else if type is Protocol {
            return NSStringFromProtocol(type as! Protocol)
        } else {
            let name = reflect(type).summary
            println("Name :\(name)")
            return name
        }
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
            implementation(injector: injector)
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
            let injectable = implementation()
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
            fatalError("Implementation type was not set! You need to call method 'to' or 'toNew' if the binded type is not Injectable or PostInitInjectable!")
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

    public private(set) var name: String
    public private(set) var type: T.Type
    public private(set) var implementation: (Injector -> T)?
    
    private init(name: String, type: T.Type) {
        self.name = name
        self.type = type
    }

}