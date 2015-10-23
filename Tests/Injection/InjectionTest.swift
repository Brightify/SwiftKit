//
//  InjectionTest.swift
//  SwiftKit
//
//  Created by Tadeáš Kříž on 5/24/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class InjectionTest: QuickSpec {

    override func spec() {
        describe("Injector") {
            it("injects implementation") {
                let module = Module()
                module.bind(UserDAO).toNew(MockUserDAO())
                module.bind(UserService).to(UserServiceImpl.init)
                
                let injector = Injector.createInjector(module)
                
                let userService = injector.get(UserService)
                expect(userService.userGreeting) == "Hello, John Mock"
            }
            
            it("injects implementation from extended Module") {
                let module = TestModule()
                let injector = Injector.createInjector(module)
                
                let userService = injector.get(UserService)
                expect(userService.userGreeting) == "Hello, John Doe"
            }
            
            it("injects implementation with key") {
                let module = Module()
                module.bindKey(Key<UIViewController>(named: "InitialController")).toNew(UIViewController())
                module.bindKey(Key<UIViewController>(named: "LastController")).toNew(UITableViewController())
                
                let injector = Injector.createInjector(module)
                
                let initialController = injector.get(Key<UIViewController>(named: "InitialController"))
                let lastController = injector.get(Key<UIViewController>(named: "LastController"))
                expect(initialController.dynamicType !== lastController.dynamicType) == true
            }
            
            it("injects an instance object") {
                let module = Module()
                module.bind(UserDAO).toNew(MockUserDAO())
                module.bind(UserService).to(UserServiceImpl.init)
                
                let injector = Injector.createInjector(module)
                let instance: Instance<UserService> = .init()
                
                instance <- injector
                
                expect(instance.get().userGreeting) == "Hello, John Mock"
            }
            
            it("injects an optional instance object") {
                let module = Module()
                module.bind(UserDAO).toNew(MockUserDAO())
                module.bind(UserService).to(UserServiceImpl.init)
                
                let injector = Injector.createInjector(module)
                let instance: OptionalInstance<UserService> = .init()
                
                instance <- injector
                
                expect(instance.get()?.userGreeting) == "Hello, John Mock"
            }
            
            it("does not fail for OptionalInstance if not bound") {
                let module = Module()
                
                let injector = Injector.createInjector(module)
                let instance: OptionalInstance<UserService> = .init()
                
                instance <- injector
                
                expect(instance.get()).to(beNil())
            }
            
            it("creates only one instance when singleton") {
                let module = Module()
                module.bind(InitCalledCounter).asSingleton()
                let injector = Injector.createInjector(module)
                expect(InitCalledCounter.timesInitCalled) == 0
                
                let firstInject = injector.get(InitCalledCounter)
                expect(InitCalledCounter.timesInitCalled) == 1
                
                let secondInject = injector.get(InitCalledCounter)
                expect(InitCalledCounter.timesInitCalled) == 1
                expect(firstInject) === secondInject
                
                let factory = injector.factory(InitCalledCounter)
                expect(InitCalledCounter.timesInitCalled) == 1
                
                let factoryFirstInject = factory.create()
                expect(InitCalledCounter.timesInitCalled) == 1
                expect(firstInject) === factoryFirstInject
                
                let factorySecondInject = factory.create()
                expect(InitCalledCounter.timesInitCalled) == 1
                expect(factoryFirstInject) === factorySecondInject
            }
            
            it("releases factory closure after instantiation when singleton") {
                let module = Module()
                var capturedObject: User? = User()
                weak var weakCapturedObject = capturedObject
                module.bind(InitCalledCounter).to { [capturedObject] in
                    capturedObject?.name
                    return InitCalledCounter(injector: $0)
                    }.asSingleton()
                capturedObject = nil
                let injector = Injector.createInjector(module)
                expect(weakCapturedObject).toNot(beNil())
                let _ = injector.get(InitCalledCounter)
                expect(weakCapturedObject).to(beNil())
            }
            
            it("works with parameters") {
                let module = Module()
                module.bind(ParametrizedService)
                let injector = Injector.createInjector(module)
                let service = injector.get(ParametrizedService.self, withParameters: (string: "Hello world", int: 4))
                expect(service.string) == "Hello world"
                expect(service.int) == 4
            }
            
            it("works with postinitparameters") {
                let module = Module()
                module.bind(PostInitParametrizedService)
                let injector = Injector.createInjector(module)
                let service = injector.get(PostInitParametrizedService.self, withParameters: (string: "Hello world", int: 4))
                expect(service.string) == "Hello world"
                expect(service.int) == 4
            }
            
            it("works with parameterized factories") {
                let module = Module()
                module.bind(ParametrizedService)
                let injector = Injector.createInjector(module)
                let serviceFactory = injector.factory(ParametrizedService)
                let service = serviceFactory.create((string: "Hello world, Joe", int: 10))
                expect(service.string) == "Hello world, Joe"
                expect(service.int) == 10
            }
        }
    }
}

private class TestModule: Module {
    
    override func configure() {
        bind(UserDAO).toNew(UserDAOImpl())
        bind(UserService).to { UserServiceImpl(injector: $0) }
    }
    
}

private protocol UserService: Injectable {
    var userGreeting: String { get }
}

private class UserServiceImpl: UserService {
    
    let dao: Factory<UserDAO>
    
    var userGreeting: String {
        return "Hello, \(dao.create().getUser().name)"
    }
    
    required init(injector: Injector) {
        dao = injector.factory(UserDAO)
    }
    
}

private class User {
    
    let name: String
    
    convenience init() {
        self.init(name: "John Doe")
    }
    
    init(name: String) {
        self.name = name
    }
    
}

private protocol UserDAO {
    
    func getUser() -> User
    
}

private class UserDAOImpl: UserDAO {
    
    func getUser() -> User {
        return User()
    }
    
}

private class MockUserDAO: UserDAO {
    
    func getUser() -> User {
        return User(name: "John Mock")
    }
    
}

private final class InitCalledCounter: Injectable {
    static var timesInitCalled = 0
    
    init(injector: Injector) {
        InitCalledCounter.timesInitCalled++
    }
}

private class ParametrizedService: ParametrizedInjectable {
    let string: String
    let int: Int
    
    required init(injector: Injector, _ p: (string: String, int: Int)) {
        self.string = p.string
        self.int = p.int
    }
    
}

private class PostInitParametrizedService: PostInitParametrizedInjectable {    
    var string: String!
    var int: Int!

    required init() { }
    
    private func inject(injector: Injector) {
    }
    
    private func postInject(parameters: (string: String, int: Int)) {
        self.string = parameters.string
        self.int = parameters.int
    }
    
}