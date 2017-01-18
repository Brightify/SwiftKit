//
//  SerializableTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class SerializableTest: QuickSpec {
    
    override func spec() {
        describe("Serializable") {
            let objectMapper = ObjectMapper()

            describe("serialize") {
                it("serializes object") {
                    var data = SerializableData(objectMapper: objectMapper)
                    
                    TestData.serializableStruct.serialize(to: &data)
                    
                    expect(data.raw) == TestData.type
                }
            }
            describe("ObjectMapper.serialize") {
                it("serializes object") {
                    expect(objectMapper.serialize(TestData.serializableStruct)) == TestData.type
                }
            }
        }
    }
}
