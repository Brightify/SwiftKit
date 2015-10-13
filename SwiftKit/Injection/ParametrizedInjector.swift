//
//  ParametrizedInjector.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 13/10/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

public class ParametrizedInjector<PARAMETERS> {
    
    let parameters: PARAMETERS
    let injector: Injector
    
    init(parameters: PARAMETERS, injector: Injector) {
        self.parameters = parameters
        self.injector = injector
    }
    
    public func get<T: Parametrizable where T.Parameters == PARAMETERS>(type: T.Type) -> T {
        return injector.get(type, withParameters: parameters)
    }
    
    public func inject<T: Parametrizable where T.Parameters == PARAMETERS>(instance: Instance<T>) {
        return injector.inject(instance, withParameters: parameters)
    }
    
    public func inject<T: Parametrizable where T.Parameters == PARAMETERS>(instance: OptionalInstance<T>) {
        return injector.inject(instance, withParameters: parameters)
    }
    
    public func factory<T: Parametrizable where T.Parameters == PARAMETERS>(type: T.Type) -> Factory<T> {
        return injector.factory(type, withParameters: parameters)
    }
    
}