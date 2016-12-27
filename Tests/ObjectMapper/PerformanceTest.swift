//
//  PerformanceTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import SwiftKit

class PerfomanceTest: XCTestCase {
    
    var objectMapper: ObjectMapper!
    
    override func setUp() {
        objectMapper = ObjectMapper()
    }
    
    func testSerialize() {
        let data = testData(x: 8)
        var result: SupportedType = .null
        measure {
             result = self.objectMapper.serialize(data)
        }
    }
    
    func testDeserialize() {
        let data: SupportedType = objectMapper.serialize(testData(x: 8))
        var result: MappableStruct! = nil
        measure {
            result = self.objectMapper.deserialize(data)
        }
    }
    
    func testSerializeWithPolymorph() {
        
    }
    
    func testDeserializeWithPolymorph() {
        
    }
    
    private func testData(x: Int) -> MappableStruct {
        var object: MappableStruct = MappableStruct(number: 0, text: "0", points: [], children: [])
        // Floor[ x! * e ] x is max i
        for i in 1...x {
            object = MappableStruct(number: i, text: "\(i)", points: (1...i).map { Double($0) }, children: (1...i).map { _ in object })
        }
        return object
    }
}

private struct MappableStruct: Mappable {
    
    private(set) var number: Int?
    private(set) var text: String = ""
    private(set) var points: [Double] = []
    private(set) var children: [MappableStruct] = []
    
    init(number: Int?, text: String, points: [Double], children: [MappableStruct]) {
        self.number = number
        self.text = text
        self.points = points
        self.children = children
    }
    
    init(_ data: DeserializableData) throws {
        try mapping(data)
    }
    
    mutating func mapping(_ data: inout MappableData) throws {
        data["number"].map(&number)
        try data["text"].map(&text)
        data["points"].map(&points, or: [])
        data["children"].map(&children, or: [])
    }
}
