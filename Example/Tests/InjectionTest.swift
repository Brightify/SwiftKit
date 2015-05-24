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
        
        XCTAssertEqual(injector.get(UserDAO).getUser().name, "John Doe")
        
        module = Module()
        
        module.bind(UserDAO).to(MockUserDAO)
        
        injector = Injector.createInjector(module)
        
        XCTAssertEqual(injector.get(UserDAO).getUser().name, "John Mock")
    }
    
    

}

class TestModule: Module {
    
    override func configure() {
        bind(UserDAO)
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

class UserDAO: Constructable {

    required init() {
        
    }
    
    func getUser() -> User {
        return User()
    }
    
}

class MockUserDAO: UserDAO {
    
    override func getUser() -> User {
        return User(name: "John Mock")
    }
    
}