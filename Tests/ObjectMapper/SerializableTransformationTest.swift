//
//  SerializableTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class SerializableTransformationTest: QuickSpec {
    
    override func spec() {
        describe("SerializableTransformation extension") {
            describe("typeErased") {
                it("returns AnySerializableTransformation") {
                    let transformation: AnySerializableTransformation<Int> = SerializableTransformationStub().typeErased()
                    
                    expect(transformation.transform(object: nil)) == SupportedType.int(1)
                }
            }
        }
    }
    
    private struct SerializableTransformationStub: SerializableTransformation {
        
        typealias Object = Int

        func transform(object: Int?) -> SupportedType {
            return .int(1)
        }
    }
}
