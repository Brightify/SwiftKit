//
//  StaticPolymorphTestData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 31.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SwiftKit

struct StaticPolymorphTestData {
    
    class A: Polymorphic {
        
        class var polymorphicKey: String {
            return "K"
        }
        
        class var polymorphicInfo: PolymorphicInfo {
            return createPolymorphicInfo().with(subtypes: B.self, C.self, D.self)
        }
    }
    
    class B: A {
    }
    
    class C: B {
        
        override class var polymorphicKey: String {
            return "C"
        }
    }
    
    class D: C {
        
        override class var polymorphicInfo: PolymorphicInfo {
            return createPolymorphicInfo(name: "D2")
        }
    }
    
    // Intentionally not registered.
    class E: D {
    }
    
    class X {
    }
}
