//
//  Operators.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/19/15.
//
//

import Foundation

infix operator <- { }

public func <- <T>(inout injectable: T!, injector: Injector) {
    var optionalInjectable: T? = injectable
    
    optionalInjectable <- injector
    
    injectable = optionalInjectable
}

public func <- <T>(inout injectable: T?, injector: Injector) {
    injectable = injector.get(T.self)
}

public func <- <T>(inout injectableFactory: Factory<T>!, injector: Injector) {
    var optionalInjectableFactory: Factory<T>? = injectableFactory
    
    optionalInjectableFactory <- injector
    
    injectableFactory = optionalInjectableFactory
}

public func <- <T>(inout injectableFactory: Factory<T>?, injector: Injector) {
    injectableFactory = injector.factory(T.self)
}

public func <- <T>(inout injectable: T!, injector: KeyedInjector) {
    var optionalInjectable: T? = injectable
    
    optionalInjectable <- injector
    
    injectable = optionalInjectable
}

public func <- <T>(inout injectable: T?, injector: KeyedInjector) {
    injectable = injector.get(T.self)
}

public func <- <T>(inout injectableFactory: Factory<T>!, injector: KeyedInjector) {
    var optionalInjectableFactory: Factory<T>? = injectableFactory
    
    optionalInjectableFactory <- injector
    
    injectableFactory = optionalInjectableFactory
}

public func <- <T>(inout injectableFactory: Factory<T>?, injector: KeyedInjector) {
    injectableFactory = injector.factory(T.self)
}
