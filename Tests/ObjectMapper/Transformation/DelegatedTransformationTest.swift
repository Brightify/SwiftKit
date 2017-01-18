//
//  DelegatedTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class DelegatedTransformationTest: QuickSpec {
    
    override func spec() {
        describe("DelegatedTransformation") {
            let transformation = DelegatedTransformationStub()
            describe("transform(from)") {
                it("transforms SupportedType using delegate") {
                    expect(transformation.transform(from: .int(1))) == 1
                }
            }
            describe("transform(object)") {
                it("transforms object using delegate and convert") {
                    expect(transformation.transform(object: 1)) == SupportedType.int(1)
                }
            }
        }
    }
    
    private struct DelegatedTransformationStub: DelegatedTransformation {
        
        typealias Object = Int
        
        var transformationDelegate: AnyTransformation<Int> = IntTransformation().typeErased()
    }
}
