//
//  AnySerializableTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class AnySerializableTransformationTest: QuickSpec {
    
    override func spec() {
        describe("AnySerializableTransformation") {
            describe("transform(object)") {
                it("calls closure from init") {
                    var called = false
                    let transformation = AnySerializableTransformation<Int>(transformObject: { _ in called = true; return .null })
                    
                    _ = transformation.transform(object: 0)
                    
                    expect(called).to(beTrue())
                }
            }
        }
    }
}
