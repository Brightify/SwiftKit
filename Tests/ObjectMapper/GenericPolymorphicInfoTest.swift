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
    
    override func spec() {
        describe("GenericPolymorphicInfo") {
            let B = StaticPolymorphTestData.B.self
            let C = StaticPolymorphTestData.C.self
            
            describe("register") {
                it("registers subtype") {
                    var info = GenericPolymorphicInfo<StaticPolymorphTestData.A>(name: "A")
                    
                    info.register(subtype: B)
                    
                    expect("\(info.registeredSubtypes)") == "\([B])"
                }
                it("accepts array") {
                    var info = GenericPolymorphicInfo<StaticPolymorphTestData.A>(name: "A")
                    
                    info.register(subtypes: [B, C])
                    
                    expect("\(info.registeredSubtypes)") == "\([B, C])"
                }
                it("accepts vararg") {
                    var info = GenericPolymorphicInfo<StaticPolymorphTestData.A>(name: "A")
                    
                    info.register(subtypes: B, C)
                    
                    expect("\(info.registeredSubtypes)") == "\([B, C])"
                }
            }
            describe("with") {
                it("returns copy of self with registered subtype") {
                    let info = GenericPolymorphicInfo<StaticPolymorphTestData.A>(name: "A")
                    
                    let info2 = info.with(subtype: B)
                    
                    expect("\(info.registeredSubtypes)") == "\([])"
                    expect("\(info2.registeredSubtypes)") == "\([B])"
                }
                it("accepts array") {
                    let info = GenericPolymorphicInfo<StaticPolymorphTestData.A>(name: "A")
                    
                    let info2 = info.with(subtypes: [B, C])
                    
                    expect("\(info.registeredSubtypes)") == "\([])"
                    expect("\(info2.registeredSubtypes)") == "\([B, C])"
                }
                it("accepts vararg") {
                    let info = GenericPolymorphicInfo<StaticPolymorphTestData.A>(name: "A")
                    
                    let info2 = info.with(subtypes: B, C)
                    
                    expect("\(info.registeredSubtypes)") == "\([])"
                    expect("\(info2.registeredSubtypes)") == "\([B, C])"
                }
            }
        }
    }
}
