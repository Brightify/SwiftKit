//
//  DelegatedSerializableTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class DelegatedSerializableTransformationTest: QuickSpec {
    
    override func spec() {
        describe("DelegatedSerializableTransformation") {
            describe("transform(object)") {
                it("transforms object using delegate and convert") {
                    let transformation = DelegatedSerializableTransformationStub()
                    
                    expect(transformation.transform(object: 1)) == SupportedType.int(1)
                }
            }
        }
    }
    
    private struct DelegatedSerializableTransformationStub: DelegatedSerializableTransformation {
        
        typealias Object = Int
        
        var serializableTransformationDelegate: AnySerializableTransformation<Int> = IntTransformation().typeErased()
    }
}
