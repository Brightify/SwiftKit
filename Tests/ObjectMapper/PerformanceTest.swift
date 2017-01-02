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
    
    private typealias Object = TestData.MappableStruct
    
    private let objectMapper = ObjectMapper()
    private let serializer = JsonSerializer()
    private let objects = TestData.generate(x: 6)
    
    // TODO Move to tests for JSONSerializer.
    func testSerializeObjectToJSON() {
        let data: Object = objects
        var result: JSON! = nil
        measure {
             result = self.serializer.typedSerialize(self.objectMapper.serialize(data))
        }
        _ = result
    }
    
    func testDeserializeJSONToObject() {
        let data: JSON = serializer.typedSerialize(objectMapper.serialize(objects))
        var result: Object! = nil
        measure {
            result = self.objectMapper.deserialize(self.serializer.typedDeserialize(data))
        }
        _ = result
    }
    
    func testSerializeSupportedTypeToJSON() {
        let data: SupportedType = objectMapper.serialize(objects)
        var result: JSON! = nil
        measure {
            result = self.serializer.typedSerialize(data)
        }
        _ = result
    }
    
    func testDeserializeJSONToSupportedType() {
        let data: JSON = serializer.typedSerialize(objectMapper.serialize(objects))
        var result: SupportedType = .null
        measure {
            result = self.serializer.typedDeserialize(data)
        }
        _ = result
    }
    
    func testSerializeObjectToSupportedType() {
        let data: Object = objects
        var result: SupportedType = .null
        measure {
            result = self.objectMapper.serialize(data)
        }
        _ = result
    }
    
    func testDeserializeSupportedTypeToObject() {
        let data: SupportedType = objectMapper.serialize(objects)
        var result: Object! = nil
        measure {
            result = self.objectMapper.deserialize(data)
        }
        _ = result
    }
}
