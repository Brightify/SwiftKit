//
//  SwiftKitTests.swift
//  SwiftKitTests
//
//  Created by Tadeas Kriz on 15/09/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

import XCTest
@testable import SwiftKit
/*
protocol A {
    var data: [Int] { get set }
}

struct B: A {
    
    var data: [Int] = Array(0..<SwiftKitTests.count)
}

class C: A {
    
    var data: [Int] = Array(0..<SwiftKitTests.count)
}
*/
class SwiftKitTests: XCTestCase {
    /*
    static var count = 1
    
    override func setUp() {
        SwiftKitTests.count = 10000
    }
    
    func testX() {
        var x = 0
        measure {
            for _ in 0..<1000000 {
                let data: A = SwiftKitTests.count > 0 ? B() : C()
                x += self.a(a: data)
            }
        }
        print(x)
    }
    
    func a(a: A) -> Int {
        var b = a
        b.data[0] = 1
        return a.data[0]
    }*/
    
    /*
     func testX() {
     var x = 0
     measure {
     for _ in 0..<100000 {
     x += A().data[0]
     }
     }
     print(x)
     }*/
    
    func testA() {
        var data = SerializableMappableDataWrapper(delegate: SerializableData(polymorph: nil))
        var x = 10
        var y = 20
        data["a"]["b"]["c"]["d"]["e"].map(&x, or: 0)
        data["a", "b", "c", "d", "f"].map(&y, or: 0)
        
        print(data.delegate.data.dictionary?["a"]?.dictionary?["b"]?.dictionary?["c"]?.dictionary?["d"]?.dictionary?["e"]?.int ?? 0)
        print(data.delegate.data.dictionary?["a"]?.dictionary?["b"]?.dictionary?["c"]?.dictionary?["d"]?.dictionary?["f"]?.int ?? 0)
    }
    /*
    func testSerializable() {
        var x = 0
        measure {
            for _ in 0..<100000 {
                
                var data = SerializableData()
                data["a", "b", "c", "d", "e"].set(1)
                data["a", "b", "c", "d", "f"].set(1)
                data["a", "b", "c", "d", "g"].set(1)
                //data["x", "y"].set(1)
                //data["x", "z"].set(2)
                
                x += data.data.dictionary?["a"]?.dictionary?["b"]?.dictionary?["c"]?.dictionary?["d"]?.dictionary?["e"]?.int ?? 0
            }
        }
        print(x)
    }
    
    func testDeserializable() {
        var x = 0
        measure {
            for _ in 0..<100000 {
                let type = SupportedType.dictionary([
                    //"x": .dictionary(["y": .int(1), "z": .int(2)]),
                    "a": .dictionary(["b": .dictionary(["c": .dictionary(["d": .dictionary(["e": .int(1)])])])])
                    ])
                
                let data = DeserializableData(data: type)
                x += data["a", "b", "c", "d", "e"].get() ?? 0
                //x += data["x", "y"].get() ?? 0
                //x += data["x", "z"].get() ?? 0
            }
        }
        print(x)
    }*/
}
