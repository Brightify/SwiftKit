//
//  PostInitInjectable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

import Foundation

public protocol PostInitInjectable {
    
    init()
    
    func inject(injector: Injector)
    
}