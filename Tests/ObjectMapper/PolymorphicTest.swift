//
//  PolymorphicTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class PolymorphicTest: QuickSpec {
    
    override func spec() {
        describe("Polymorphic extension") {
            let A = StaticPolymorphTestData.A.self

            describe("createPolymorphicInfo") {
                it("creates GenericPolymorphicInfo of type Self named as type") {
                    let info = A.createPolymorphicInfo()
                    
                    expect(info.name) == "A"
                    expect("\(info.type)") == "\(A)"
                }
            }
            describe("createPolymorphicInfo(String)") {
                it("creates GenericPolymorphicInfo of type Self named as parameter") {
                    let info = A.createPolymorphicInfo(name: "Name")
                    
                    expect(info.name) == "Name"
                    expect("\(info.type)") == "\(A)"
                }
            }
        }
    }
}
