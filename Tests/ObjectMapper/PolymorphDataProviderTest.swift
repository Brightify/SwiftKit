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
    
    private typealias A = TestData.StaticPolymorph.A
    private typealias B = TestData.StaticPolymorph.B
    private typealias C = TestData.StaticPolymorph.C
    private typealias D = TestData.StaticPolymorph.D
    // E is not registered subtype of A.
    private typealias E = TestData.StaticPolymorph.E
    
    override func spec() {
        describe("PolymorphDataProvider") {
            let provider = PolymorphDataProvider()
            describe("nameAndKey") {
                it("returns name and key corresponding to type") {
                    expect(provider.nameAndKey(of: A.self) == (name: "A", key: "K")).to(beTrue())
                    expect(provider.nameAndKey(of: B.self) == (name: "B", key: "K")).to(beTrue())
                    expect(provider.nameAndKey(of: C.self) == (name: "C", key: "C")).to(beTrue())
                    expect(provider.nameAndKey(of: D.self) == (name: "D2", key: "C")).to(beTrue())
                    expect(provider.nameAndKey(of: E.self) == (name: "E", key: "C")).to(beTrue())
                }
            }
            describe("keys") {
                it("returns all keys used by type hiearchy") {
                    expect(provider.keys(of: A.self)) == Set(arrayLiteral: "K", "C")
                    expect(provider.keys(of: B.self)) == Set(arrayLiteral: "K", "C")
                    
                    expect(provider.keys(of: C.self)) == Set(arrayLiteral: "C")
                    expect(provider.keys(of: D.self)) == Set(arrayLiteral: "C")
                    expect(provider.keys(of: E.self)) == Set(arrayLiteral: "C")
                }
            }
            describe("polymorphType") {
                it("returns subtype corresponding to name and key in type hiearchy") {
                    expect("\(provider.polymorphType(of: A.self, named: "A", forKey: "K"))") == "\(A.self as Polymorphic.Type?)"
                    expect("\(provider.polymorphType(of: A.self, named: "B", forKey: "K"))") == "\(B.self as Polymorphic.Type?)"
                    expect("\(provider.polymorphType(of: A.self, named: "C", forKey: "C"))") == "\(C.self as Polymorphic.Type?)"
                    expect("\(provider.polymorphType(of: A.self, named: "D2", forKey: "C"))") == "\(D.self as Polymorphic.Type?)"
                    
                    expect("\(provider.polymorphType(of: B.self, named: "B", forKey: "K"))") == "\(B.self as Polymorphic.Type?)"
                    expect("\(provider.polymorphType(of: B.self, named: "C", forKey: "C"))") == "\(C.self as Polymorphic.Type?)"
                    expect("\(provider.polymorphType(of: B.self, named: "D2", forKey: "C"))") == "\(D.self as Polymorphic.Type?)"
                    
                    expect("\(provider.polymorphType(of: C.self, named: "C", forKey: "C"))") == "\(C.self as Polymorphic.Type?)"
                    
                    expect("\(provider.polymorphType(of: D.self, named: "D2", forKey: "C"))") == "\(D.self as Polymorphic.Type?)"
                    
                    expect("\(provider.polymorphType(of: E.self, named: "E", forKey: "C"))") == "\(E.self as Polymorphic.Type?)"
                }
                it("returns nil if name and key does not exist") {
                    expect(provider.polymorphType(of: A.self, named: "X", forKey: "K")).to(beNil())
                    expect(provider.polymorphType(of: A.self, named: "C", forKey: "K")).to(beNil())
                    expect(provider.polymorphType(of: A.self, named: "D", forKey: "C")).to(beNil())
                }
                it("returns nil if referred type is supertype") {
                    expect(provider.polymorphType(of: B.self, named: "A", forKey: "K")).to(beNil())
                }
                it("returns nil if referred type is not registered") {
                    expect(provider.polymorphType(of: A.self, named: "E", forKey: "C")).to(beNil())
                }
                it("returns nil if referred type is not registered in type hiearchy") {
                    expect(provider.polymorphType(of: C.self, named: "D2", forKey: "C")).to(beNil())
                }
            }
        }
    }
}
