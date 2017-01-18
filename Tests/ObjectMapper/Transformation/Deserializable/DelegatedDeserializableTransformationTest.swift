//
//  DelegatedDeserializableTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class DelegatedDeserializableTransformationTest: QuickSpec {
    
    override func spec() {
        describe("DelegatedDeserializableTransformation") {
            describe("transform(from)") {
                it("transforms SupportedType using delegate") {
                    let transformation = DelegatedDeserializableTransformationStub()
                    
                    expect(transformation.transform(from: .int(1))) == 1
                }
            }
        }
    }
    
    private struct DelegatedDeserializableTransformationStub: DelegatedDeserializableTransformation {
        
        typealias Object = Int
        
        var deserializableTransformationDelegate: AnyDeserializableTransformation<Int> = IntTransformation().typeErased()
    }
}
