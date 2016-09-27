//
//  ParametrizedInjector.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 13/10/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

open class ParametrizedInjector<PARAMETERS> {
    
    let parameters: PARAMETERS
    let injector: Injector
    
    init(parameters: PARAMETERS, injector: Injector) {
        self.parameters = parameters
        self.injector = injector
    }
    
    open func get<T: Parametrizable>(_ type: T.Type) -> T where T.Parameters == PARAMETERS {
        return injector.get(type, withParameters: parameters)
    }
    
    open func inject<T: Parametrizable>(_ instance: Instance<T>) where T.Parameters == PARAMETERS {
        return injector.inject(instance, withParameters: parameters)
    }
    
    open func inject<T: Parametrizable>(_ instance: OptionalInstance<T>) where T.Parameters == PARAMETERS {
        return injector.inject(instance, withParameters: parameters)
    }
    
    open func factory<T: Parametrizable>(_ type: T.Type) -> Factory<T> where T.Parameters == PARAMETERS {
        return injector.factory(type, withParameters: parameters)
    }
    
}
