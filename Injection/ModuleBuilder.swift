//
//  ModuleBuilder.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import Foundation

public class Module {
    
    public private(set) var bindings: [String: Binding] = [:]
    
    public init() {
        
    }
    
    public func configure() {
    }
    
    public func bind<T: Constructable>(type: T.Type) -> BindingBuilder<T> {
        return bindAnyObject(type)
    }
    
    public func bind<T: Injectable>(type: T.Type) -> BindingBuilder<T> {
        return bindAnyObject(type)
    }
    
    func bindingForType<T: AnyObject>(type: T.Type) -> Binding? {
        let typeName = NSStringFromClass(type)
        return bindings[typeName]
    }
    
    private func bindAnyObject<T: AnyObject>(type: T.Type) -> BindingBuilder<T> {
        let typeName = NSStringFromClass(type)
        var binding: Binding = Binding(type: type)
        bindings[typeName] = binding
        return BindingBuilder(binding: binding)
    }
    
}

public class BindingBuilder<T: AnyObject> {
    
    private var binding: Binding

    private init(binding: Binding) {
        self.binding = binding
    }

    public func to(implementation: T.Type) {
        binding.implementation = implementation
    }

}

public class Binding {

    public private(set) var type: Any
    public private(set) var implementation: Any
    
    private init(type: Any) {
        self.type = type
        self.implementation = type
    }

}