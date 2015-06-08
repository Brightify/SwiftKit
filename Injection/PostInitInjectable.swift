//
//  PostInitInjectable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

import Foundation

// If the protocol is not constrained to class only, compiler will fail when used with UIViewController
public protocol PostInitInjectable: class {
    
    init()
    
    func inject(injector: Injector)
    
}