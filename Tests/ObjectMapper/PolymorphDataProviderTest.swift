//
//  PolymorphDataProviderTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class PolymorphDataProviderTest: QuickSpec {
    
    override func spec() {
        describe("PolymorphDataProvider") {
            let A = StaticPolymorphTestData.A.self
            let B = StaticPolymorphTestData.B.self
            let C = StaticPolymorphTestData.C.self
            let D = StaticPolymorphTestData.D.self
            // E is not registered subtype of A.
            let E = StaticPolymorphTestData.E.self
            
            let provider = PolymorphDataProvider()
            describe("nameAndKey") {
                it("returns name and key corresponding to type") {
                    expect(provider.nameAndKey(of: A) == (name: "A", key: "K")).to(beTrue())
                    expect(provider.nameAndKey(of: B) == (name: "B", key: "K")).to(beTrue())
                    expect(provider.nameAndKey(of: C) == (name: "C", key: "C")).to(beTrue())
                    expect(provider.nameAndKey(of: D) == (name: "D2", key: "C")).to(beTrue())
                    expect(provider.nameAndKey(of: E) == (name: "E", key: "C")).to(beTrue())
                }
            }
            describe("keys") {
                it("returns all keys used by type hiearchy") {
                    expect(provider.keys(of: A)) == Set(arrayLiteral: "K", "C")
                    expect(provider.keys(of: B)) == Set(arrayLiteral: "K", "C")
                    
                    expect(provider.keys(of: C)) == Set(arrayLiteral: "C")
                    expect(provider.keys(of: D)) == Set(arrayLiteral: "C")
                    expect(provider.keys(of: E)) == Set(arrayLiteral: "C")
                }
            }
            describe("polymorphType") {
                it("returns subtype corresponding to name and key in type hiearchy") {
                    expect("\(provider.polymorphType(of: A, named: "A", forKey: "K"))") == "\(A as Polymorphic.Type?)"
                    expect("\(provider.polymorphType(of: A, named: "B", forKey: "K"))") == "\(B as Polymorphic.Type?)"
                    expect("\(provider.polymorphType(of: A, named: "C", forKey: "C"))") == "\(D as Polymorphic.Type?)"
                    expect("\(provider.polymorphType(of: A, named: "D2", forKey: "C"))") == "\(D as Polymorphic.Type?)"
                    
                    expect("\(provider.polymorphType(of: B, named: "B", forKey: "K"))") == "\(B as Polymorphic.Type?)"
                    expect("\(provider.polymorphType(of: B, named: "C", forKey: "C"))") == "\(D as Polymorphic.Type?)"
                    expect("\(provider.polymorphType(of: B, named: "D2", forKey: "C"))") == "\(D as Polymorphic.Type?)"
                    
                    expect("\(provider.polymorphType(of: C, named: "C", forKey: "C"))") == "\(D as Polymorphic.Type?)"
                    expect("\(provider.polymorphType(of: C, named: "D2", forKey: "C"))") == "\(D as Polymorphic.Type?)"
                    
                    expect("\(provider.polymorphType(of: D, named: "D2", forKey: "C"))") == "\(D as Polymorphic.Type?)"
                    
                    expect("\(provider.polymorphType(of: E, named: "E", forKey: "C"))") == "\(E as Polymorphic.Type?)"
                }
                it("returns nil if name and key does not exist") {
                    expect(provider.polymorphType(of: A, named: "X", forKey: "K")).to(beNil())
                    expect(provider.polymorphType(of: A, named: "C", forKey: "K")).to(beNil())
                    expect(provider.polymorphType(of: A, named: "D", forKey: "C")).to(beNil())
                }
                it("returns nil if referred type is supertype") {
                    expect(provider.polymorphType(of: B, named: "A", forKey: "K")).to(beNil())
                }
                it("returns nil if referred type is not registered") {
                    expect(provider.polymorphType(of: A, named: "E", forKey: "C")).to(beNil())
                }
            }
        }
    }
}
