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
    
    override func spec() {
        describe("StaticPolymorph") {
            let A = StaticPolymorphTestData.A.self
            let C = StaticPolymorphTestData.C.self
            let X = StaticPolymorphTestData.X.self
            
            let polymorph = StaticPolymorph()
            let data = SupportedType.dictionary(["C": .string("C")])
            describe("polymorphType") {
                it("returns polymorphic type based on data in SupportedType") {
                    let type = polymorph.polymorphType(for: A, in: data)
                    
                    expect("\(type)") == "\(C)"
                }
                it("returns passed type if type is not polymorphic") {
                    let type = polymorph.polymorphType(for: X, in: data)
                    
                    expect("\(type)") == "\(X)"
                }
                it("returns passed type if no subtype mathing SupportedType") {
                    let type = polymorph.polymorphType(for: A, in: .dictionary(["K": .string("C")]))
                    
                    expect("\(type)") == "\(A)"
                }
            }
            describe("writeTypeInfo") {
                it("writes info about type in SupportedType") {
                    var type = SupportedType.null
                    
                    polymorph.writeTypeInfo(to: &type, of: C)
                    
                    expect(type) == data
                }
                it("does nothing if type is not polymorphic") {
                    var type = SupportedType.null
                    
                    polymorph.writeTypeInfo(to: &type, of: X)
                    
                    expect(type) == SupportedType.null
                }
            }
        }
    }
}
