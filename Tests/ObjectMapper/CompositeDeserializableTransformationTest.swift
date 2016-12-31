//
//  CompositeDeserializableTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class CompositeDeserializableTransformationTest: QuickSpec {
    
    override func spec() {
        describe("CompositeDeserializableTransformation") {
            describe("transform(from)") {
                it("transforms SupportedType using delegate and convert") {
                    let transformation = CompositeDeserializableTransformationStub()
                    
                    expect(transformation.transform(from: .int(1))) == "1"
                }
            }
        }
    }
    
    private struct CompositeDeserializableTransformationStub: CompositeDeserializableTransformation {
        
        typealias Object = String
        
        var deserializableTransformationDelegate: AnyDeserializableTransformation<Int> = IntTransformation().typeErased()
        
        func convert(from value: Int?) -> String? {
            return value.map { "\($0)" }
        }
    }
}
