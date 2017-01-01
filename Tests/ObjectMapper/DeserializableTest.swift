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
            let type = SupportedType.dictionary(["number": .int(1), "text": .string("a")])
            
            describe("init") {
                it("creates object") {
                    let data = DeserializableData(data: type, objectMapper: objectMapper)
                    
                    let object = try? DeserializableStruct(data)
                    
                    expect(object?.number) == 1
                    expect(object?.text) == "a"
                }
                it("throws error if SupportedType is invalid") {
                    let data = DeserializableData(data: .dictionary(["number": .int(1)]), objectMapper: objectMapper)
                    
                    let object = try? DeserializableStruct(data)
                    
                    expect(object).to(beNil())
                }
            }
            describe("ObjectMapper.deserialize") {
                it("deserializes object") {
                    let object: DeserializableStruct? = objectMapper.deserialize(type)
                    
                    expect(object?.number) == 1
                    expect(object?.text) == "a"
                }
            }
        }
    }
}

private struct DeserializableStruct: Deserializable {
    
    let number: Int?
    let text: String
    
    init(_ data: DeserializableData) throws {
        number = data["number"].get()
        text = try data["text"].get()
    }
}
