//
//  ModuleBuilder.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

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
    
    public func bind<T: protocol<AnyObject, ParametrizedInjectable>>(type: T.Type) -> ParametrizedInjectableBindingBuilder<T> {
        return ParametrizedInjectableBindingBuilder(binding: createTypeBinding(inferredType()))
    }
    
    public func bind<T: protocol<AnyObject, PostInitParametrizedInjectable>>(type: T.Type) -> PostInitParametrizedInjectableBindingBuilder<T> {
        return PostInitParametrizedInjectableBindingBuilder(binding: createTypeBinding(inferredType()))
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

    public func to(implementation: T.Type) -> AdvancedUseBinder<T> {
        binding.implementation = { injector in
            implementation.init(injector: injector)
        }
        
        return AdvancedUseBinder<T>(binding: binding)
    }
    
    public func asSingleton() {
        AdvancedUseBinder(binding: binding).asSingleton()
    }
    
    public func asThreadLocal() {
        AdvancedUseBinder(binding: binding).asThreadLocal()
    }
}

public class PostInitInjectableBindingBuilder<T: protocol<AnyObject, PostInitInjectable>> {
    private var binding: Binding<T>
    
    private init(binding: Binding<T>) {
        self.binding = binding
        
        // We use the same type as a default implementation.
        to(T)
    }
    
    public func to(implementation: T.Type) -> AdvancedUseBinder<T> {
        binding.implementation = { injector in
            let injectable = implementation.init()
            injectable.inject(injector)
            return injectable
        }
        
        return AdvancedUseBinder(binding: binding)
    }
    
    public func asSingleton() {
        AdvancedUseBinder(binding: binding).asSingleton()
    }
    
    public func asThreadLocal() {
        AdvancedUseBinder(binding: binding).asThreadLocal()
    }
}

public class ParametrizedInjectableBindingBuilder<T: ParametrizedInjectable> {
    private var binding: Binding<T.InitParameters -> T>
    
    private init(binding: Binding<T.InitParameters -> T>) {
        self.binding = binding
        
        to(T)
    }
    
    public func to(implementation: T.Type) {
        binding.implementation = { injector in
            { parameters in
                implementation.init(injector: injector, parameters)
            }
        }
    }
}

public class PostInitParametrizedInjectableBindingBuilder<T: PostInitParametrizedInjectable> {
    private var binding: Binding<T.PostInitParameters -> T>
    
    private init(binding: Binding<T.PostInitParameters -> T>) {
        self.binding = binding
        
        to(T)
    }
    
    public func to(implementation: T.Type) {
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
    
    public func to(closure: (injector: Injector) -> T) -> AdvancedUseBinder<T> {
        binding.implementation = { injector in
            closure(injector: injector)
        }
        
        return AdvancedUseBinder(binding: binding)
    }
    
    public func toNew(@autoclosure(escaping) closure: () -> T) -> AdvancedUseBinder<T> {
        return to { _ in
            closure()
        }
    }
}

public class AdvancedUseBinder<T> {
    private var binding: Binding<T>
    
    private init(binding: Binding<T>) {
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
    private let value: T
    private init(_ value: T) {
        self.value = value
    }
}

internal class Binding<T> {

    internal private(set) var type: T.Type
    internal private(set) var implementation: (Injector -> T)?
    
    private init(type: T.Type) {
        self.type = type
    }

}