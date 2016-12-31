//
//  EnumTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 31.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class EnumTransformationTest: QuickSpec {
    
    override func spec() {
        describe("EnumTransformation") {
            enum X: Int {
                case A = 0
                case B = 1
            }
            let transformation = EnumTransformation<X>()
            let value = X.B
            let type: SupportedType = .int(1)
            let incorrectType: SupportedType = .double(1)
            
            describe("init") {
                it("accepts rawValueTransformation") {
                    let transformation = EnumTransformation<X>(rawValueTransformation: IntTransformation())
                    
                    expect(transformation.transform(from: type)?.rawValue) == value.rawValue
                }
                it("uses defaultTransformation if type is SupportedTypeConvertible") {
                    let transformation = EnumTransformation<X>()
                    
                    expect(transformation.transform(from: type)?.rawValue) == value.rawValue
                }
            }
            describe("transform(from)") {
                it("transforms correct SupportedType to value") {
                    expect(transformation.transform(from: type)?.rawValue) == value.rawValue
                }
                it("transforms incorrect SupportedType to nil") {
                    expect(transformation.transform(from: incorrectType)).to(beNil())
                }
            }
            describe("transform(object)") {
                it("transforms value to SupportedType") {
                    expect(transformation.transform(object: value)) == type
                }
                it("transforms nil to SupportedType.null") {
                    expect(transformation.transform(object: nil)) == SupportedType.null
                }
            }
        }
    }
}
