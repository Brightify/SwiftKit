//
//  TestUtilsTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 27.06.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class TestUtilsTest: QuickSpec {
    
    override func spec() {
        describe("TestUtils") {
            describe("wasDeinit") {
                it("returns true if instance has no reference cycle") {
                    let result = QuickUtils.wasDeinit {
                        TestableClassWithoutReferenceCycle()
                    }
                    expect(result) == true
                }
                
                it("returns true if instance has weak reference cycle") {
                    let result = QuickUtils.wasDeinit {
                        var testableClass = TestableClassWithWeakReferenceCycle()
                        testableClass.classWithDelegate = ClassWithDelegate(delegate: testableClass)
                        return testableClass
                    }
                    expect(result) == true
                }
                
                it("returns false if instance has strong reference cycle") {
                    let result = QuickUtils.wasDeinit {
                        var testableClass = TestableClassWithStrongReferenceCycle()
                        testableClass.classWithDelegate = ClassWithDelegate(delegate: testableClass)
                        return testableClass
                    }
                    expect(result) == false
                }
            }

            describe("assertDeinit") {
                it("passes if instance has no reference cycle") {
                    QuickUtils.assertDeinit {
                        TestableClassWithoutReferenceCycle()
                    }
                }
                
                it("passes if instance has weak reference cycle") {
                    QuickUtils.assertDeinit {
                        var testableClass = TestableClassWithWeakReferenceCycle()
                        testableClass.classWithDelegate = ClassWithDelegate(delegate: testableClass)
                        return testableClass
                    }
                }
                
                // There cannot be any fails test because Quick doesn't support negative tests.
            }
        }
    }
    
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
