//
//  AnyDeserializableTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class AnyDeserializableTransformationTest: QuickSpec {
    
    override func spec() {
        describe("AnyDeserializableTransformation") {
            describe("transform(from)") {
                it("calls closure from init") {
                    var called = false
                    let transformation = AnyDeserializableTransformation(transformFrom: { _ -> Int in called = true; return 0 })
                    
                    _ = transformation.transform(from: .null)
                    
                    expect(called).to(beTrue())
                }
            }
        }
    }
}
