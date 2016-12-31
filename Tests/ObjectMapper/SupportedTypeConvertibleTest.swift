//
//  SupportedTypeConvertibleTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class SupportedTypeConvertibleTest: QuickSpec {
    
    override func spec() {
        describe("SupportedTypeConvertible") {
            it("can be used in ObjectMapper without transformation") {
                let objectMapper = ObjectMapper()
                let value: SupportedTypeConvertibleStub? = SupportedTypeConvertibleStub()
                let type: SupportedType = .null
                
                let result: SupportedTypeConvertibleStub? = objectMapper.deserialize(type)
                expect("\(result)") == "\(value)"
                expect(objectMapper.serialize(value)) == type
            }
        }
    }
    
    private struct SupportedTypeConvertibleStub: SupportedTypeConvertible {
        
        static let defaultTransformation: AnyTransformation<SupportedTypeConvertibleStub> =
            AnyTransformation(transformFrom: { _ in SupportedTypeConvertibleStub() }, transformObject: { _ in .null })
    }
}
