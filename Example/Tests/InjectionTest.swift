//
//  InjectionTest.swift
//  SwiftKit
//
//  Created by Tadeáš Kříž on 5/24/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import UIKit
import XCTest
import SwiftKit

class InjectionTest: XCTestCase {

    override func setUp() {
        super.setUp()
        // Put setup code here. This method is called before the invocation of each test method in the class.
    }
    
    override func tearDown() {
        // Put teardown code here. This method is called after the invocation of each test method in the class.
        super.tearDown()
    }

    func testInjection() {

        var module: Module = TestModule()
        
        var injector = Injector.createInjector(module)
        
        XCTAssertEqual(injector.get(UserService).userGreeting, "Hello, John Doe")
        
        module = Module()
        
        module.bind(UserDAO).toNew(MockUserDAO())
        module.bind(UserService).to { UserServiceImpl(injector: $0) }
        
        injector = Injector.createInjector(module)
        
        XCTAssertEqual(injector.get(UserService).userGreeting, "Hello, John Mock")
    }
    
    

}

class TestModule: Module {
    
    override func configure() {
        bind(UserDAO).toNew(UserDAOImpl())
        bind(UserService).to { UserServiceImpl(injector: $0) }
    }
    
}

protocol UserService: Injectable {
    
    var userGreeting: String { get }
    
}

class UserServiceImpl: UserService {
    
    let dao: Factory<UserDAO>
    
    var userGreeting: String {
        return "Hello, \(dao.create().getUser().name)"
    }
    
    required init(injector: Injector) {
        dao = injector.factory(UserDAO)
    }
    
}

class MockUserService: UserServiceImpl {
    
    override var userGreeting: String {
        return "Guten tag, \(dao.create().getUser().name)"
    }
    
}

class User {
    
    let name: String
    
    convenience init() {
        self.init(name: "John Doe")
    }
    
    init(name: String) {
        self.name = name
    }
    
}

protocol UserDAO {
    
    func getUser() -> User
    
}

class UserDAOImpl: UserDAO {
    
    func getUser() -> User {
        return User()
    }
    
}

class MockUserDAO: UserDAO {
    
    func getUser() -> User {
        return User(name: "John Mock")
    }
    
}