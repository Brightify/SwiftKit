//
//  Operators.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/19/15.
//
//

import Foundation

infix operator <- { }

func <- <T>(inout injectable: T!, injector: Injector) {
    var optionalInjectable: T? = injectable
    
    optionalInjectable <- injector
    
    injectable = optionalInjectable
}

func <- <T>(inout injectable: T?, injector: Injector) {
    injectable = injector.get(T.self)
}

func <- <T>(inout injectableFactory: Factory<T>!, injector: Injector) {
    var optionalInjectableFactory: Factory<T>? = injectableFactory
    
    optionalInjectableFactory <- injector
    
    injectableFactory = optionalInjectableFactory
}

func <- <T>(inout injectableFactory: Factory<T>?, injector: Injector) {
    injectableFactory = injector.factory(T.self)
}

func <- <T>(inout injectable: T!, injector: KeyedInjector) {
    var optionalInjectable: T? = injectable
    
    optionalInjectable <- injector
    
    injectable = optionalInjectable
}

func <- <T>(inout injectable: T?, injector: KeyedInjector) {
    injectable = injector.get(T.self)
}

func <- <T>(inout injectableFactory: Factory<T>!, injector: KeyedInjector) {
    var optionalInjectableFactory: Factory<T>? = injectableFactory
    
    optionalInjectableFactory <- injector
    
    injectableFactory = optionalInjectableFactory
}

func <- <T>(inout injectableFactory: Factory<T>?, injector: KeyedInjector) {
    injectableFactory = injector.factory(T.self)
}
