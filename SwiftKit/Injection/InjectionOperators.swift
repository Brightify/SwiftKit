//
//  Operators.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/19/15.
//
//

import Foundation

infix operator <- { associativity right }

public func <- <T>(inout injectable: T!, injector: Injector) {
    injectable = injector.get(T.self)
}

public func <- <T>(inout injectable: T?, injector: Injector) {
    injectable = injector.get(T.self)
}

public func <- <T>(inout injectableFactory: Factory<T>!, injector: Injector) {
    injectableFactory = injector.factory(T.self)
}

public func <- <T>(inout injectableFactory: Factory<T>?, injector: Injector) {
    injectableFactory = injector.factory(T.self)
}

public func <- <T>(instance: Instance<T>, injector: Injector) {
    injector.inject(instance)
}

public func <- <T>(instance: OptionalInstance<T>, injector: Injector) {
    injector.inject(instance)
}

public func <- (injector: Injector, keyName: String) -> KeyedInjector {
    return injector[keyName]
}

public func <- <T>(inout injectable: T!, injector: KeyedInjector) {
    injectable = injector.get(T.self)
}

public func <- <T>(inout injectable: T?, injector: KeyedInjector) {
    injectable = injector.get(T.self)
}

public func <- <T>(inout injectableFactory: Factory<T>!, injector: KeyedInjector) {
    injectableFactory = injector.factory(T.self)
}

public func <- <T>(inout injectableFactory: Factory<T>?, injector: KeyedInjector) {
    injectableFactory = injector.factory(T.self)
}

public func <- <T>(instance: Instance<T>, injector: KeyedInjector) {
    injector.inject(instance)
}

public func <- <T>(instance: OptionalInstance<T>, injector: KeyedInjector) {
    injector.inject(instance)
}

public func <- <PARAMETERS>(injector: Injector, parameters: PARAMETERS) -> ParametrizedInjector<PARAMETERS> {
    return ParametrizedInjector(parameters: parameters, injector: injector)
}

public func <- <T: Parametrizable>(inout injectable: T!, injector: ParametrizedInjector<T.Parameters>) {
    injectable = injector.get(T.self)
}

public func <- <T: Parametrizable>(inout injectable: T?, injector: ParametrizedInjector<T.Parameters>) {
    injectable = injector.get(T.self)
}

public func <- <T: Parametrizable>(inout injectableFactory: ParametrizedFactory<T>!, injector: Injector) {
    injectableFactory = injector.factory(T.self)
}

public func <- <T: Parametrizable>(inout injectableFactory: ParametrizedFactory<T>?, injector: Injector) {
    injectableFactory = injector.factory(T.self)
}

public func <- <T: Parametrizable>(inout injectable: Factory<T>!, injector: ParametrizedInjector<T.Parameters>) {
    injectable = injector.factory(T.self)
}

public func <- <T: Parametrizable>(inout injectable: Factory<T>?, injector: ParametrizedInjector<T.Parameters>) {
    injectable = injector.factory(T.self)
}

public func <- <T: Parametrizable>(instance: Instance<T>, injector: ParametrizedInjector<T.Parameters>) {
    injector.inject(instance)
}

public func <- <T: Parametrizable>(instance: OptionalInstance<T>, injector: ParametrizedInjector<T.Parameters>) {
    injector.inject(instance)
}

