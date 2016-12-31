//
//  PerformanceTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import XCTest
import SwiftKit
import SwiftyJSON

class PerfomanceTest: XCTestCase {
    
    var objectMapper: ObjectMapper!
    var serializer: JsonSerializer!
    
    private let x = 7
    
    override func setUp() {
        objectMapper = ObjectMapper()
        serializer = JsonSerializer()
    }
    
    func testSerialize() {
        let data = testData(x: x)
        var result: JSON! = nil
        measure {
             result = self.serializer.typedSerialize(self.objectMapper.serialize(data))
        }
        _ = result
    }
    
    func testDeserialize() {
        let data: JSON = serializer.typedSerialize(objectMapper.serialize(testData(x: x)))
        var result: MappableStruct! = nil
        measure {
            result = self.objectMapper.deserialize(self.serializer.typedDeserialize(data))
        }
        _ = result
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
