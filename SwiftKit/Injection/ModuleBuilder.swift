//
//  ModuleBuilder.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import SwiftKitStaging

private func == (lhs: Module.KeyedBindingsMapKey, rhs: Module.KeyedBindingsMapKey) -> Bool {
    return lhs.name == rhs.name && lhs.typeIdentifier == rhs.typeIdentifier
}

/// Module is used to create all bindings in the project
open class Module {
    
    fileprivate struct KeyedBindingsMapKey: Hashable {
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
    fileprivate var plainBindings: [ObjectIdentifier: AnyObject] = [:]
    // We need to use Int as the key because of the missing generic covariance in Swift. The key's value has to be the Key<T>'s hashValue.
    fileprivate var keyedBindings: [KeyedBindingsMapKey: AnyObject] = [:] // [Key<Any>: AnyObject] = [:]
    
    open var allowUnboundFactories: Bool = false
    
    public init() {
        
    }
    
    open func configure() {
    }
    
    open func bind<T>(_ type: T.Type) -> ClosureBindingBuilder<T> {
        return ClosureBindingBuilder(binding: createTypeBinding(type))
    }
    
    open func bind<T: AnyObject & Injectable>(_ type: T.Type) -> BindingBuilder<T> {
        return BindingBuilder(binding: createTypeBinding(type))
    }
    
    open func bind<T: AnyObject & PostInitInjectable>(_ type: T.Type) -> PostInitInjectableBindingBuilder<T> {
        return PostInitInjectableBindingBuilder(binding: createTypeBinding(type))
    }
    
    open func bind<T: AnyObject & ParametrizedInjectable>(_ type: T.Type) -> ParametrizedInjectableBindingBuilder<T> {
        return ParametrizedInjectableBindingBuilder(binding: createTypeBinding(inferredType()))
    }
    
    open func bind<T: AnyObject & PostInitParametrizedInjectable>(_ type: T.Type) -> PostInitParametrizedInjectableBindingBuilder<T> {
        return PostInitParametrizedInjectableBindingBuilder(binding: createTypeBinding(inferredType()))
    }
    
    open func bindKey<T>(_ key: Key<T>) -> ClosureBindingBuilder<T> {
        return ClosureBindingBuilder(binding: createKeyBinding(key))
    }
    
    open func bindKey<T: AnyObject & Injectable>(_ key: Key<T>) -> BindingBuilder<T> {
        return BindingBuilder(binding: createKeyBinding(key))
    }
    
    open func bindKey<T: AnyObject & PostInitInjectable>(_ key: Key<T>) -> PostInitInjectableBindingBuilder<T> {
        return PostInitInjectableBindingBuilder(binding: createKeyBinding(key))
    }
    
    func bindingForType<T>(_ type: T.Type) -> Binding<T>? {
        return plainBindings[ObjectIdentifier(type)] as? Binding<T>
    }
    
    func bindingForKey<T>(_ key: Key<T>) -> Binding<T>? {
        let bindingKey = KeyedBindingsMapKey(key: key)
        return keyedBindings[bindingKey] as? Binding<T>
    }
    
    fileprivate func createTypeBinding<T>(_ type: T.Type) -> Binding<T> {
        let binding: Binding = Binding<T>(type: type)
        plainBindings[ObjectIdentifier(type)] = binding
        return binding
    }
    
    fileprivate func createKeyBinding<T>(_ key: Key<T>) -> Binding<T> {
        let bindingKey = KeyedBindingsMapKey(key: key)
        let binding = Binding<T>(type: T.self)
        keyedBindings[bindingKey] = binding
        return binding
    }

}

open class BindingBuilder<T: AnyObject & Injectable> {
    
    fileprivate var binding: Binding<T>

    fileprivate init(binding: Binding<T>) {
        self.binding = binding
        
        // We use the same type as a default implementation.
        to(T.self)
    }

    @discardableResult
    open func to(_ implementation: T.Type) -> AdvancedUseBinder<T> {
        binding.implementation = { injector in
            implementation.init(injector: injector)
        }
        
        return AdvancedUseBinder<T>(binding: binding)
    }
    
    open func asSingleton() {
        AdvancedUseBinder(binding: binding).asSingleton()
    }
    
    open func asThreadLocal() {
        AdvancedUseBinder(binding: binding).asThreadLocal()
    }
}

open class PostInitInjectableBindingBuilder<T: AnyObject & PostInitInjectable> {
    fileprivate var binding: Binding<T>

    fileprivate init(binding: Binding<T>) {
        self.binding = binding
        
        // We use the same type as a default implementation.
        to(T.self)
    }
    
    open func to(_ implementation: T.Type) -> AdvancedUseBinder<T> {
        binding.implementation = { injector in
            let injectable = implementation.init()
            injectable.inject(injector)
            return injectable
        }
        
        return AdvancedUseBinder(binding: binding)
    }
    
    open func asSingleton() {
        AdvancedUseBinder(binding: binding).asSingleton()
    }
    
    open func asThreadLocal() {
        AdvancedUseBinder(binding: binding).asThreadLocal()
    }
}

open class ParametrizedInjectableBindingBuilder<T: ParametrizedInjectable> {
    fileprivate var binding: Binding<(T.Parameters) -> T>
    
    fileprivate init(binding: Binding<(T.Parameters) -> T>) {
        self.binding = binding
        
        to(T.self)
    }
    
    open func to(_ implementation: T.Type) {
        binding.implementation = { injector in
            { parameters in
                implementation.init(injector: injector, parameters)
            }
        }
    }
}

open class PostInitParametrizedInjectableBindingBuilder<T: PostInitParametrizedInjectable> {
    fileprivate var binding: Binding<(T.Parameters) -> T>
    
    fileprivate init(binding: Binding<(T.Parameters) -> T>) {
        self.binding = binding
        
        to(T.self)
    }
    
    open func to(_ implementation: T.Type) {
        binding.implementation = { injector in
            { parameters in
                let injectable = implementation.init()
                injectable.inject(injector)
                injectable.postInject(parameters)
                return injectable
            }
        }
    }
}

open class ClosureBindingBuilder<T> {
    
    fileprivate var binding: Binding<T>
    
    fileprivate init(binding: Binding<T>) {
        self.binding = binding
        
        binding.implementation = { _ in
            // We need to use `assert(false, ...)` because if `fatalError` is used, we get a warning on the return line.
            assert(false, "Implementation type was not set! You need to call method 'to' or 'toNew' if the binded type is not Injectable or PostInitInjectable!")
            // Without this line the compiler thinks this closure is not (Injector -> T) and does not compile.
            return nil as T!
        }
    }

    @discardableResult
    open func to(_ closure: @escaping (_ injector: Injector) -> T) -> AdvancedUseBinder<T> {
        binding.implementation = { injector in
            closure(injector)
        }
        
        return AdvancedUseBinder(binding: binding)
    }

    @discardableResult
    open func toNew( _ closure: @autoclosure @escaping () -> T) -> AdvancedUseBinder<T> {
        return to { _ in
            closure()
        }
    }
}

open class AdvancedUseBinder<T> {
    fileprivate var binding: Binding<T>
    
    fileprivate init(binding: Binding<T>) {
        self.binding = binding
    }
}

// TODO T should be AnyObject, because it does not make sense to have ThreadLocal structs. Swift however does not support more complex generic constructs yet
extension AdvancedUseBinder /*where T: AnyObject*/ {
    public func asSingleton() {
        var implementation = binding.implementation
        var singleton: T? = nil
        binding.implementation = { injector in
            if singleton == nil {
                singleton = implementation?(injector)
                // We need to release the original closure after we run it.
                implementation = nil
            }
            
            if let singleton = singleton {
                return singleton
            } else {
                fatalError("Could not instantiate the singleton of type \(T.self)!")
            }
        }
    }
    
    // We need to use the Box<T>, because we cannot constrain T to "AnyObject" yet
    public func asThreadLocal() {
        guard let implementation = binding.implementation else {
            fatalError("Implementation was nil! Cannot create ThreadLocal with nil implementation.")
        }
        let container = ThreadLocalParametrized {
            Box(implementation($0))
        }
        binding.implementation = { injector in
            return container.get(injector).value
        }
    }
}

private class Box<T> {
    fileprivate let value: T
    fileprivate init(_ value: T) {
        self.value = value
    }
}

internal class Binding<T> {

    internal fileprivate(set) var type: T.Type
    internal fileprivate(set) var implementation: ((Injector) -> T)?
    
    fileprivate init(type: T.Type) {
        self.type = type
    }

}
