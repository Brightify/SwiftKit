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
                module.bind(UserService).to { UserServiceImpl(injector: $0) }
                
                let injector = Injector.createInjector(module)
                
                expect(injector.get(UserService).userGreeting) == "Hello, John Mock"
            }
            
            it("injects implementation from extended Module") {
                let module = TestModule()
                let injector = Injector.createInjector(module)
                
                expect(injector.get(UserService).userGreeting) == "Hello, John Doe"
            }
            
            it("injects implementation with key") {
                let module = Module()
                module.bindKey(Key<UIViewController>(named: "InitialController")).toNew(UIViewController())
                module.bindKey(Key<UIViewController>(named: "LastController")).toNew(UITableViewController())
                
                let injector = Injector.createInjector(module)
                
                let initialController = injector.get(Key<UIViewController>(named: "InitialController"))
                let lastController = injector.get(Key<UIViewController>(named: "LastController"))
                expect(NSStringFromClass(initialController.dynamicType)) != NSStringFromClass(lastController.dynamicType)
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