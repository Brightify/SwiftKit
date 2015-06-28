//
//  Injectable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import Foundation

/// Injectable protocol must be implemented in every class that is injected in Injection
public protocol Injectable {
    
    /**
    * Initializes a class with Injector
    * :param: injector The injector that injects the depenencies
    */
    init(injector: Injector)
    
}