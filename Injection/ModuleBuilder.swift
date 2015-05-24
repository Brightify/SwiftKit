//
//  ModuleBuilder.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import Foundation

public class Module {
    
    public private(set) var bindings: [String: AnyObject] = [:]
    
    public init() {
        
    }
    
    public func configure() {
    }
    
    public func bind<T>(type: T.Type) -> ClosureBindingBuilder<T> {
        return ClosureBindingBuilder(binding: bindAnyObject(type))
    }
    
    public func bind<T: protocol<AnyObject, Injectable>>(type: T.Type) -> BindingBuilder<T> {
        return BindingBuilder(binding: bindAnyObject(type))
    }
    
    func bindingForType<T>(type: T.Type) -> Binding<T>? {
        let typeName = stringFromType(type)
        return bindings[typeName] as? Binding<T>
    }
    
    private func bindAnyObject<T>(type: T.Type) -> Binding<T> {
        let typeName = stringFromType(type)
        var binding: Binding = Binding<T>(type: type)
        bindings[typeName] = binding
        return binding
    }
    
    private func stringFromType<T>(type: T.Type) -> String {
        if let classType: AnyClass = type as? AnyClass {
            return NSStringFromClass(classType)
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
    }

    public func to(implementation: T.Type) {
        binding.implementation = { injector in
            implementation(injector: injector)
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

public class Binding<T> {

    public private(set) var type: T.Type
    public private(set) var implementation: (Injector -> T)?
    
    private init(type: T.Type) {
        self.type = type
    }

}