//
//  DeserializableTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class DeserializableTest: QuickSpec {
    
    override func spec() {
        describe("Deserializable") {
            let objectMapper = ObjectMapper()
            describe("init") {
                it("creates object") {
                    let data = DeserializableData(data: TestData.type, objectMapper: objectMapper)
                    
                    expect(try? TestData.DeserializableStruct(data)) == TestData.deserializableStruct
                }
                it("throws error if SupportedType is invalid") {
                    let data = DeserializableData(data: TestData.invalidType, objectMapper: objectMapper)

                    expect(try? TestData.DeserializableStruct(data)).to(beNil())
                }
            }
            describe("ObjectMapper.deserialize") {
                it("deserializes object") {
                    let result: TestData.DeserializableStruct? = objectMapper.deserialize(TestData.type)
                    
                    expect(result) == TestData.deserializableStruct
                }
            }
        }
    }
}
