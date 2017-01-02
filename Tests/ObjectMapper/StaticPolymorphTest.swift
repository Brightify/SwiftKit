//
//  StaticPolymorphTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class StaticPolymorphTest: QuickSpec {
    
    private typealias A = TestData.StaticPolymorph.A
    private typealias C = TestData.StaticPolymorph.C
    private typealias X = TestData.StaticPolymorph.X
    
    override func spec() {
        describe("StaticPolymorph") {
            let polymorph = StaticPolymorph()
            let data = SupportedType.dictionary(["C": .string("C")])
            describe("polymorphType") {
                it("returns polymorphic type based on data in SupportedType") {
                    let type = polymorph.polymorphType(for: A.self, in: data)
                    
                    expect("\(type)") == "\(C.self)"
                }
                it("returns passed type if type is not polymorphic") {
                    let type = polymorph.polymorphType(for: X.self, in: data)
                    
                    expect("\(type)") == "\(X.self)"
                }
                it("returns passed type if no subtype mathing SupportedType") {
                    let type = polymorph.polymorphType(for: A.self, in: .dictionary(["K": .string("C")]))
                    
                    expect("\(type)") == "\(A.self)"
                }
            }
            describe("writeTypeInfo") {
                it("writes info about type in SupportedType") {
                    var type = SupportedType.null
                    
                    polymorph.writeTypeInfo(to: &type, of: C.self)
                    
                    expect(type) == data
                }
                it("does nothing if type is not polymorphic") {
                    var type = SupportedType.null
                    
                    polymorph.writeTypeInfo(to: &type, of: X.self)
                    
                    expect(type) == SupportedType.null
                }
            }
        }
    }
}
