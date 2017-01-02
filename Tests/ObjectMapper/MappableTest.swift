//
//  MappableTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class MappableTest: QuickSpec {
    
    override func spec() {
        describe("Mappable") {
            let objectMapper = ObjectMapper()

            describe("init") {
                it("creates class") {
                    let data = DeserializableData(data: TestData.type, objectMapper: objectMapper)
                    
                    expect(try? TestData.MappableClass(data)) == TestData.mappableClass
                }
                it("creates struct") {
                    let data = DeserializableData(data: TestData.type, objectMapper: objectMapper)
                    
                    expect(try? TestData.MappableStruct(data)) == TestData.mappableStruct
                }
                it("throws error if SupportedType is invalid") {
                    let data = DeserializableData(data: TestData.invalidType, objectMapper: objectMapper)
                    
                    expect(try? TestData.MappableStruct(data)).to(beNil())
                }
            }
            describe("serialize") {
                it("serializes object") {
                    var data = SerializableData(objectMapper: objectMapper)
                    
                    TestData.mappableStruct.serialize(to: &data)
                    
                    expect(data.data) == TestData.type
                }
            }
            describe("ObjectMapper.deserialize") {
                it("deserializes object") {
                    let object: TestData.MappableStruct? = objectMapper.deserialize(TestData.type)
                    
                    expect(object) == TestData.mappableStruct
                }
            }
            describe("ObjectMapper.serialize") {
                it("serializes object") {
                    expect(objectMapper.serialize(TestData.mappableStruct)) == TestData.type
                }
            }
        }
    }
}
