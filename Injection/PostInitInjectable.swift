//
//  PostInitInjectable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

import Foundation

// If the protocol is not constrained to class only, compiler will fail when used with UIViewController
/// This protocol is used by classes that inject dependecies after the initialization
public protocol PostInitInjectable: class {
    
    // Initialize
    init()
    
    /**
        Injects dependencies to the target class
    
        :param: injector The Injector used to inject dependencies
    */
    func inject(injector: Injector)
    
}