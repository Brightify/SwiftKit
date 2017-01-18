//
//  CompositeSerializableTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class CompositeSerializableTransformationTest: QuickSpec {
    
    override func spec() {
        describe("CompositeSerializableTransformation") {
            describe("transform(object)") {
                it("transforms object using delegate and convert") {
                    let transformation = CompositeSerializableTransformationStub()
                    
                    expect(transformation.transform(object: "1")) == SupportedType.int(1)
                }
            }
        }
    }

    private struct CompositeSerializableTransformationStub: CompositeSerializableTransformation {
        
        typealias Object = String
        
        var serializableTransformationDelegate: AnySerializableTransformation<Int> = IntTransformation().typeErased()
        
        func convert(object: String?) -> Int? {
            return object.flatMap { Int($0) }
        }
    }
}
