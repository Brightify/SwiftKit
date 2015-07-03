//
//  ModuleBuilder.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import Foundation

public class Key<T> {
    
    public let name: String
    
    public init(named: String) {
        name = named
    }
}

public class Module {
    
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
        binding.implementation = { injector in
            T(injector: injector)
        }
    }

    public func to(implementation: T.Type) {
        binding.implementation = { injector in
            implementation(injector: injector)
        }
    }
}

public class PostInitInjectableBindingBuilder<T: protocol<AnyObject, PostInitInjectable>> {
    private var binding: Binding<T>
    
    private init(binding: Binding<T>) {
        self.binding = binding
        
        binding.implementation = { injector in
            let injectable = T()
            injectable.inject(injector)
            return injectable
        }
    }
    
    public func to(implementation: T.Type) {
        binding.implementation = { injector in
            let injectable = implementation()
            injectable.inject(injector)
            return injectable
        }
    }
}

public class ClosureBindingBuilder<T> {
    
    private var binding: Binding<T>
    
    private init(binding: Binding<T>) {
        self.binding = binding
    }
    
    public func to(closure: (injector: Injector) -> T) {
        binding.implementation = { injector in
            closure(injector: injector)
        }
    }
    
    public func toNew(@autoclosure(escaping) closure: () -> T) {
        to { _ in
            closure()
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