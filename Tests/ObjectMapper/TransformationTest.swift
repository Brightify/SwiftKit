//
//  TransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class TransformationTest: QuickSpec {
    
    override func spec() {
        describe("Transformation extension") {
            describe("typeErased") {
                it("returns AnyTransformation") {
                    let transformation: AnyTransformation<Int> = TransformationStub().typeErased()
                    
                    expect(transformation.transform(from: .null)) == 1
                    expect(transformation.transform(object: nil)) == SupportedType.int(1)
                }
            }
        }
    }
    
    struct TransformationStub: Transformation {
        
        typealias Object = Int
        
        func transform(from value: SupportedType) -> Int? {
            return 1
        }
        
        func transform(object: Int?) -> SupportedType {
            return .int(1)
        }
    }
}
