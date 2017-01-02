//
//  GenericPolymorphicInfoTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftKit

class GenericPolymorphicInfoTest: QuickSpec {
    
    private typealias A = TestData.StaticPolymorph.A
    private typealias B = TestData.StaticPolymorph.B
    private typealias C = TestData.StaticPolymorph.C
    
    override func spec() {
        describe("GenericPolymorphicInfo") {
            describe("register") {
                it("registers subtype") {
                    var info = GenericPolymorphicInfo<A>(name: "A")
                    
                    info.register(subtype: B.self)
                    
                    expect("\(info.registeredSubtypes)") == "\([B.self])"
                }
                it("accepts array") {
                    var info = GenericPolymorphicInfo<A>(name: "A")
                    
                    info.register(subtypes: [B.self, C.self])
                    
                    expect("\(info.registeredSubtypes)") == "\([B.self, C.self])"
                }
                it("accepts vararg") {
                    var info = GenericPolymorphicInfo<A>(name: "A")
                    
                    info.register(subtypes: B.self, C.self)
                    
                    expect("\(info.registeredSubtypes)") == "\([B.self, C.self])"
                }
            }
            describe("with") {
                it("returns copy of self with registered subtype") {
                    let info = GenericPolymorphicInfo<A>(name: "A")
                    
                    let info2 = info.with(subtype: B.self)
                    
                    expect("\(info.registeredSubtypes)") == "\([])"
                    expect("\(info2.registeredSubtypes)") == "\([B.self])"
                }
                it("accepts array") {
                    let info = GenericPolymorphicInfo<A>(name: "A")
                    
                    let info2 = info.with(subtypes: [B.self, C.self])
                    
                    expect("\(info.registeredSubtypes)") == "\([])"
                    expect("\(info2.registeredSubtypes)") == "\([B.self, C.self])"
                }
                it("accepts vararg") {
                    let info = GenericPolymorphicInfo<A>(name: "A")
                    
                    let info2 = info.with(subtypes: B.self, C.self)
                    
                    expect("\(info.registeredSubtypes)") == "\([])"
                    expect("\(info2.registeredSubtypes)") == "\([B.self, C.self])"
                }
            }
        }
    }
}
