//
//  Factory.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import Foundation

public class Factory<T> {
    
    let factoryClosure: () -> T
    
    init(closure: () -> T) {
        factoryClosure = closure
    }
    
    func create() -> T {
        return factoryClosure()
    }
    
}