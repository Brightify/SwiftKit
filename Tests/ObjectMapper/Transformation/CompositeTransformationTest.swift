//
//  CompositeTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class CompositeTransformationTest: QuickSpec {
    
    override func spec() {
        describe("CompositeTransformation") {
            let transformation = CompositeTransformationStub()
            describe("transform(from)") {
                it("transforms SupportedType using delegate and convert") {
                    expect(transformation.transform(from: .int(1))) == "1"
                }
            }
            describe("transform(object)") {
                it("transforms object using delegate and convert") {
                    expect(transformation.transform(object: "1")) == SupportedType.int(1)
                }
            }
        }
    }
    
    private struct CompositeTransformationStub: CompositeTransformation {
        
        typealias Object = String
        
        var transformationDelegate: AnyTransformation<Int> = IntTransformation().typeErased()
        
        func convert(object: String?) -> Int? {
            return object.flatMap { Int($0) }
        }
        
        func convert(from value: Int?) -> String? {
            return value.map { "\($0)" }
        }
    }
}
