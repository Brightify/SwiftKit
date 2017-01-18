//
//  SerializableData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class SerializableDataTest: QuickSpec {
    
    private typealias CustomIntTransformation = TestData.CustomIntTransformation
    
    override func spec() {
        describe("SerializableData") {
            describe("serialize") {
                describe("serializable") {
                    it("sets data if value is not nil") {
                        var data = SerializableData(objectMapper: ObjectMapper())
                        
                        let value: Int? = 1
                        let array: [Int]? = [1, 2]
                        let dictionary: [String: Int]? = ["a": 1, "b": 2]
                        let optionalArray: [Int?]? = [1, nil]
                        let optionalDictionary: [String: Int?]? = ["a": 1, "b": nil]
                        
                        data["value"].set(value)
                        data["array"].set(array)
                        data["dictionary"].set(dictionary)
                        data["optionalArray"].set(optionalArray)
                        data["optionalDictionary"].set(optionalDictionary)
                        
                        expect(data.raw) == TestData.Map.validType
                    }
                    it("sets .null if value is nil") {
                        var data = SerializableData(objectMapper: ObjectMapper())
                        
                        let value: Int? = nil
                        let array: [Int]? = nil
                        let dictionary: [String: Int]? = nil
                        let optionalArray: [Int?]? = nil
                        let optionalDictionary: [String: Int?]? = nil
                        
                        data["value"].set(value)
                        data["array"].set(array)
                        data["dictionary"].set(dictionary)
                        data["optionalArray"].set(optionalArray)
                        data["optionalDictionary"].set(optionalDictionary)
                        
                        expect(data.raw) == TestData.Map.nullType
                    }
                }
                describe("using transformation") {
                    it("sets data if value is not nil") {
                        var data = SerializableData(objectMapper: ObjectMapper())
                        
                        let valueTransformation: Int? = 2
                        let arrayTransformation: [Int]? = [2, 4]
                        let dictionaryTransformation: [String: Int]? = ["a": 2, "b": 4]
                        let optionalArrayTransformation: [Int?]? = [2, nil]
                        let optionalDictionaryTransformation: [String: Int?]? = ["a": 2, "b": nil]
                        
                        data["value"].set(valueTransformation, using: CustomIntTransformation())
                        data["array"].set(arrayTransformation, using: CustomIntTransformation())
                        data["dictionary"].set(dictionaryTransformation, using: CustomIntTransformation())
                        data["optionalArray"].set(optionalArrayTransformation, using: CustomIntTransformation())
                        data["optionalDictionary"].set(optionalDictionaryTransformation, using: CustomIntTransformation())
                        
                        expect(data.raw) == TestData.Map.validType
                    }
                    it("sets .null if value is nil") {
                        var data = SerializableData(objectMapper: ObjectMapper())
                        
                        let valueTransformation: Int? = nil
                        let arrayTransformation: [Int]? = nil
                        let dictionaryTransformation: [String: Int]? = nil
                        let optionalArrayTransformation: [Int?]? = nil
                        let optionalDictionaryTransformation: [String: Int?]? = nil
                        
                        data["value"].set(valueTransformation, using: CustomIntTransformation())
                        data["array"].set(arrayTransformation, using: CustomIntTransformation())
                        data["dictionary"].set(dictionaryTransformation, using: CustomIntTransformation())
                        data["optionalArray"].set(optionalArrayTransformation, using: CustomIntTransformation())
                        data["optionalDictionary"].set(optionalDictionaryTransformation, using: CustomIntTransformation())
                        
                        expect(data.raw) == TestData.Map.nullType
                    }
                }
            }
            describe("subscript") {
                let value: Int? = 1
                
                it("sets data with subData") {
                    var data = SerializableData(objectMapper: ObjectMapper(polymorph: StaticPolymorph()))
                    
                    data["a"]["b"].set(value)
                    
                    expect(data.raw) == TestData.Map.pathType
                }
                it("accepts array") {
                    var data = SerializableData(objectMapper: ObjectMapper(polymorph: StaticPolymorph()))
                    
                    data[["a", "b"]].set(value)
                    
                    expect(data.raw) == TestData.Map.pathType
                }
                it("accepts vararg") {
                    var data = SerializableData(objectMapper: ObjectMapper(polymorph: StaticPolymorph()))
                    
                    data["a", "b"].set(value)
                    
                    expect(data.raw) == TestData.Map.pathType
                }
                it("passes correct ObjectMapper") {
                    var data = SerializableData(objectMapper: ObjectMapper(polymorph: StaticPolymorph()))
                    
                    expect(data["a"].objectMapper) === data.objectMapper
                }
            }
        }
    }
}
