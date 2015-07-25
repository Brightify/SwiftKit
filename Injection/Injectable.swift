//
//  Injectable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import Foundation

/**
    This protocol declares a required initializer that is used to instantiate an object in the dependency injection 
    context. It is preferred to use this protocol over the `PostInitInjectable`, because you can inject properties as
    constant `let` and non-nilable.
*/
public protocol Injectable {
    
    /**
        Initializes a class with Injector
    
        :param: injector The injector that can be used to inject dependencies into the child object.
    */
    init(injector: Injector)
    
}