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
            let object = MappableStruct(number: 1, text: "a")
            let type = SupportedType.dictionary(["number": .int(1), "text": .string("a")])
            let resultType = SupportedType.dictionary(["id": .int(1), "number": .int(1), "text": .string("a")])
            
            describe("init") {
                it("creates class") {
                    let data = DeserializableData(data: type, objectMapper: objectMapper)
                    
                    let object = try? MappableClass(data)
                    
                    expect(object?.number) == 1
                    expect(object?.text) == "a"
                }
                it("creates struct") {
                    let data = DeserializableData(data: type, objectMapper: objectMapper)
                    
                    let object = try? MappableStruct(data)
                    
                    expect(object?.number) == 1
                    expect(object?.text) == "a"
                }
                it("throws error if SupportedType is invalid") {
                    let data = DeserializableData(data: .dictionary(["number": .int(1)]), objectMapper: objectMapper)
                    
                    let object = try? MappableStruct(data)
                    
                    expect(object).to(beNil())
                }
            }
            describe("serialize") {
                it("serializes object") {
                    var data = SerializableData(objectMapper: objectMapper)
                    
                    object.serialize(to: &data)
                    
                    expect(data.data) == resultType
                }
            }
            describe("ObjectMapper.deserialize") {
                it("deserializes object") {
                    let object: MappableStruct? = objectMapper.deserialize(type)
                    
                    expect(object?.number) == 1
                    expect(object?.text) == "a"
                }
            }
            describe("ObjectMapper.serialize") {
                it("serializes object") {
                    expect(objectMapper.serialize(object)) == resultType
                }
            }
        }
    }
}

private struct MappableStruct: Mappable {
    
    var number: Int?
    var text: String = ""
    
    init(number: Int?, text: String) {
        self.number = number
        self.text = text
    }
    
    init(_ data: DeserializableData) throws {
        try mapping(data)
    }
    
    func serialize(to data: inout SerializableData) {
        mapping(&data)
        
        data["id"].set(1)
    }
    
    mutating func mapping(_ data: inout MappableData) throws {
        data["number"].map(&number)
        try data["text"].map(&text)
    }
}

private class MappableClass: Mappable {
    
    var number: Int?
    var text: String = ""
    
    init(number: Int?, text: String) {
        self.number = number
        self.text = text
    }
    
    required init(_ data: DeserializableData) throws {
        try mapping(data)
    }
    
    func mapping(_ data: inout MappableData) throws {
        data["number"].map(&number)
        try data["text"].map(&text)
    }
}
