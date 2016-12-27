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
            describe("deserialize") {
                it("deserializes class") {
                    
                }
                it("deserializes struct") {
                    
                }
            }
            describe("serialize") {
                it("serializes object") {
                    
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
