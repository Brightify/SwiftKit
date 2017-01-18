//
//  SerializableSupportedTypeConvertibleTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class SerializableSupportedTypeConvertibleTest: QuickSpec {
    
    override func spec() {
        describe("SerializableSupportedTypeConvertible") {
            it("can be used in ObjectMapper without transformation") {
                let objectMapper = ObjectMapper()
                let value = SerializableSupportedTypeConvertibleStub()
                let type: SupportedType = .null
                
                expect(objectMapper.serialize(value)) == type
            }
        }
    }

    private struct SerializableSupportedTypeConvertibleStub: SerializableSupportedTypeConvertible {
        
        static let defaultSerializableTransformation: AnySerializableTransformation<SerializableSupportedTypeConvertibleStub> =
            AnySerializableTransformation(transformObject: { _ in .null })
    }
}
