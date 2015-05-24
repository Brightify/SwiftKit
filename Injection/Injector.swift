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
    
    public func get<T: Injectable>(type: T.Type) -> T {
        return getFactory(type).create()
    }
    
    public func get<T: Constructable>(type: T.Type) -> T {
        return getFactory(type).create()
    }
    
    public func getFactory<T: Injectable>(type: T.Type) -> Factory<T> {
        let implementationType = getImplementationType(type)
        return Factory<T> {
            implementationType(injector: self)
        }
    }
    
    public func getFactory<T: Constructable>(type: T.Type) -> Factory<T> {
        let implementationType = getImplementationType(type)
        return Factory<T> {
            implementationType()
        }
    }
    
    public class func createInjector(module: Module) -> Injector {
        module.configure()
        let injector = Injector(module: module)
        return injector
    }

    private func getImplementationType<T: AnyObject>(type: T.Type) -> T.Type {
        let binding = module.bindingForType(type)
        if let implementationType = binding?.implementation as? T.Type {
            return implementationType
        } else {
            fatalError("Binding for type \(type) was \(binding)")
        }
    }
    
}