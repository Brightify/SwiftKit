//
//  EventDeinitializationTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 27.06.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import SwiftKit
import XCTest

class TestUtilsTest: XCTestCase {
    
    func testWasDeinit_noReferenceCycle_returnsTrue() {
        let result = TestUtils.wasDeinit {
            TestableClassWithoutReferenceCycle()
        }
        XCTAssertTrue(result, "Deinit wasn't called.")
    }
    
    func testWasDeinit_weakReferenceCycle_returnsTrue() {
        let result = TestUtils.wasDeinit {
            var testableClass = TestableClassWithWeakReferenceCycle()
            testableClass.classWithDelegate = ClassWithDelegate(delegate: testableClass)
            return testableClass
        }
        XCTAssertTrue(result, "Deinit wasn't called.")
    }

    func testWasDeinit_strongReferenceCycle_returnsFalse() {
        let result = TestUtils.wasDeinit {
            var testableClass = TestableClassWithStrongReferenceCycle()
            testableClass.classWithDelegate = ClassWithDelegate(delegate: testableClass)
            return testableClass
        }
        XCTAssertFalse(result, "Deinit was called.")
    }
    
    func testAssertDeinit_noReferenceCycle_returnsTrue() {
        TestUtils.assertDeinit {
            TestableClassWithoutReferenceCycle()
        }
    }
    
    func testAssertDeinit_weakReferenceCycle_returnsTrue() {
        TestUtils.assertDeinit {
            var testableClass = TestableClassWithWeakReferenceCycle()
            testableClass.classWithDelegate = ClassWithDelegate(delegate: testableClass)
            return testableClass
        }
    }
    
    // There cannot be any testAssertDeinit_strongReferenceCycle_returnsFalse because XCTest doesn't support negative tests
}

private class TestableClassWithoutReferenceCycle: Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    init() {
        
    }
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}

private class TestableClassWithWeakReferenceCycle: Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    weak var classWithDelegate: ClassWithDelegate!
    
    init() {
        
    }
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}

private class TestableClassWithStrongReferenceCycle: Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    var classWithDelegate: ClassWithDelegate!
    
    init() {
        
    }
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}

private class ClassWithDelegate {
    
    let delegate: Deinitializable
    
    init(delegate: Deinitializable) {
        self.delegate = delegate
    }
    
}
