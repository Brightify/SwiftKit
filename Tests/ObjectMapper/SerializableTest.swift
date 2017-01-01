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
            let object = SerializableStruct(number: 1, text: "a")
            let type = SupportedType.dictionary(["number": .int(1), "text": .string("a")])
            
            describe("serialize") {
                it("serializes object") {
                    var data = SerializableData(objectMapper: objectMapper)
                    
                    object.serialize(to: &data)
                    
                    expect(data.data) == type
                }
            }
            describe("ObjectMapper.serialize") {
                it("serializes object") {
                    expect(objectMapper.serialize(object)) == type
                }
            }
        }
    }
}

private struct SerializableStruct: Serializable {
    
    var number: Int?
    var text: String = ""
    
    init(number: Int?, text: String) {
        self.number = number
        self.text = text
    }
    
    func serialize(to data: inout SerializableData) {
        data["number"].set(number)
        data["text"].set(text)
    }
}

