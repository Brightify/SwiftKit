//
//  Module.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import Foundation

public class Injector {
    
    let module: Module
    
    init(module: Module) {
        self.module = module
    }
    
    public func get<T>(type: T.Type) -> T {
        return getInitializationClosure(type)(self)
    }
    
    public func factory<T>(type: T.Type) -> Factory<T> {
        let initializationClosure = getInitializationClosure(type)
        return Factory<T>(injector: self, closure: initializationClosure)
    }
    
    public class func createInjector(module: Module) -> Injector {
        module.configure()
        let injector = Injector(module: module)
        return injector
    }
    
    private func getInitializationClosure<T>(type: T.Type) -> Injector -> T {
        let binding = module.bindingForType(type)
        if let injectionClosure = binding?.implementation {
            return injectionClosure
        } else {
            fatalError("Binding for type \(type) was \(binding)")
        }
    }
}