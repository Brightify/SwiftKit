//
//  SwiftKitTests.swift
//  SwiftKitTests
//
//  Created by Tadeas Kriz on 15/09/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

import XCTest
@testable import SwiftKit

class SwiftKitTests: XCTestCase {
    
    func testX() {
        print(String(describing: SwiftKitTests.self))
    }
    
    func testA() {
        var data = SerializableMappableDataWrapper()
        var x = 10
        var y = 20
        data["a"]["b"]["c"]["d"]["e"].map(&x, or: 0)
        data["a", "b", "c", "d", "f"].map(&y, or: 0)
        
        print(data.delegate.data.dictionary?["a"]?.dictionary?["b"]?.dictionary?["c"]?.dictionary?["d"]?.dictionary?["e"]?.int ?? 0)
        print(data.delegate.data.dictionary?["a"]?.dictionary?["b"]?.dictionary?["c"]?.dictionary?["d"]?.dictionary?["f"]?.int ?? 0)
    }
    
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
    }
}
