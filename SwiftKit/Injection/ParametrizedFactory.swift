//
//  ParametrizedFactory.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 13/10/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

open class ParametrizedFactory<T: Parametrizable>: Factory<(T.Parameters) -> T> {
    
    override init(closure: @escaping () -> (T.Parameters) -> T) {
        super.init(closure: closure)
    }
    
    override init(injector: Injector, closure: @escaping (Injector) -> (T.Parameters) -> T) {
        super.init(injector: injector, closure: closure)
    }
    
    open func create(_ parameters: T.Parameters) -> T {
        return create()(parameters)
    }
    
}
