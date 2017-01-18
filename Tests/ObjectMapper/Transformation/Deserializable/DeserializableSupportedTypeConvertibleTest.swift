//
//  DeserializableSupportedTypeConvertibleTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class DeserializableSupportedTypeConvertibleTest: QuickSpec {
    
    override func spec() {
        describe("DeserializableSupportedTypeConvertible") {
            it("can be used in ObjectMapper without transformation") {
                let objectMapper = ObjectMapper()
                let value: DeserializableSupportedTypeConvertibleStub? = DeserializableSupportedTypeConvertibleStub()
                let type: SupportedType = .null
                
                let result: DeserializableSupportedTypeConvertibleStub? = objectMapper.deserialize(type)
                expect("\(result)") == "\(value)"
            }
        }
    }
    
    private struct DeserializableSupportedTypeConvertibleStub: DeserializableSupportedTypeConvertible {
        
        static let defaultDeserializableTransformation: AnyDeserializableTransformation<DeserializableSupportedTypeConvertibleStub> =
            AnyDeserializableTransformation(transformFrom: { _ in DeserializableSupportedTypeConvertibleStub() })
    }
}
