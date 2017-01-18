//
//  AnyTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class AnyTransformationTest: QuickSpec {
    
    override func spec() {
        describe("AnyTransformation") {
            describe("transform(from)") {
                it("calls closure from init") {
                    var called = false
                    let transformation = AnyTransformation(transformFrom: { _ -> Int in called = true; return 0 }, transformObject: { _ in .null })
                    
                    _ = transformation.transform(from: .null)
                    
                    expect(called).to(beTrue())
                }
            }
            describe("transform(object)") {
                it("calls closure from init") {
                    var called = false
                    let transformation = AnyTransformation(transformFrom: { _ in 0 }, transformObject: { _ in called = true; return .null })
                    
                    _ = transformation.transform(object: 0)
                    
                    expect(called).to(beTrue())
                }
            }
        }
    }
}
