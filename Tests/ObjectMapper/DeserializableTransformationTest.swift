//
//  DeserializableTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class DeserializableTransformationTest: QuickSpec {
    
    override func spec() {
        describe("DeserializableTransformation extension") {
            describe("typeErased") {
                it("returns AnyDeserializableTransformation") {
                    let transformation: AnyDeserializableTransformation<Int> = DeserializableTransformationStub().typeErased()
                    
                    expect(transformation.transform(from: .null)) == 1
                }
            }
        }
    }

    private struct DeserializableTransformationStub: DeserializableTransformation {
        
        typealias Object = Int
        
        func transform(from value: SupportedType) -> Int? {
            return 1
        }
    }
}
