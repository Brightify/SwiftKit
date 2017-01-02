//
//  SerializableMappableDataWrapperTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class SerializableMappableDataWrapperTest: QuickSpec {
    
    private typealias CustomIntTransformation = TestData.CustomIntTransformation
    
    override func spec() {
        describe("SerializableMappableDataWrapper") {
            describe("map optional") {
                describe("mappable") {
                    it("sets data if value is not nil") {
                        let delegate = SerializableData(objectMapper: ObjectMapper())
                        var data: MappableData = SerializableMappableDataWrapper(delegate: delegate)
                        
                        var value: Int? = 1
                        var array: [Int]? = [1, 2]
                        var dictionary: [String: Int]? = ["a": 1, "b": 2]
                        var optionalArray: [Int?]? = [1, nil]
                        var optionalDictionary: [String: Int?]? = ["a": 1, "b": nil]
                        
                        data["value"].map(&value)
                        data["array"].map(&array)
                        data["dictionary"].map(&dictionary)
                        data["optionalArray"].map(&optionalArray)
                        data["optionalDictionary"].map(&optionalDictionary)
                        
                        expect((data as? SerializableMappableDataWrapper)?.delegate.data) == TestData.Map.validType
                    }
                    it("sets .null if value is nil") {
                        let delegate = SerializableData(objectMapper: ObjectMapper())
                        var data: MappableData = SerializableMappableDataWrapper(delegate: delegate)
                        
                        var value: Int?
                        var array: [Int]?
                        var dictionary: [String: Int]?
                        var optionalArray: [Int?]?
                        var optionalDictionary: [String: Int?]?
                        
                        data["value"].map(&value)
                        data["array"].map(&array)
                        data["dictionary"].map(&dictionary)
                        data["optionalArray"].map(&optionalArray)
                        data["optionalDictionary"].map(&optionalDictionary)
                        
                        expect((data as? SerializableMappableDataWrapper)?.delegate.data) == TestData.Map.nullType
                    }
                }
                describe("using transformation") {
                    it("sets data if value is not nil") {
                        let delegate = SerializableData(objectMapper: ObjectMapper())
                        var data: MappableData = SerializableMappableDataWrapper(delegate: delegate)
                        
                        var valueTransformation: Int? = 2
                        var arrayTransformation: [Int]? = [2, 4]
                        var dictionaryTransformation: [String: Int]? = ["a": 2, "b": 4]
                        var optionalArrayTransformation: [Int?]? = [2, nil]
                        var optionalDictionaryTransformation: [String: Int?]? = ["a": 2, "b": nil]
                        
                        data["value"].map(&valueTransformation, using: CustomIntTransformation())
                        data["array"].map(&arrayTransformation, using: CustomIntTransformation())
                        data["dictionary"].map(&dictionaryTransformation, using: CustomIntTransformation())
                        data["optionalArray"].map(&optionalArrayTransformation, using: CustomIntTransformation())
                        data["optionalDictionary"].map(&optionalDictionaryTransformation, using: CustomIntTransformation())
                        
                        expect((data as? SerializableMappableDataWrapper)?.delegate.data) == TestData.Map.validType
                    }
                    it("sets .null if value is nil") {
                        let delegate = SerializableData(objectMapper: ObjectMapper())
                        var data: MappableData = SerializableMappableDataWrapper(delegate: delegate)
                        
                        var valueTransformation: Int?
                        var arrayTransformation: [Int]?
                        var dictionaryTransformation: [String: Int]?
                        var optionalArrayTransformation: [Int?]?
                        var optionalDictionaryTransformation: [String: Int?]?
                        
                        data["value"].map(&valueTransformation, using: CustomIntTransformation())
                        data["array"].map(&arrayTransformation, using: CustomIntTransformation())
                        data["dictionary"].map(&dictionaryTransformation, using: CustomIntTransformation())
                        data["optionalArray"].map(&optionalArrayTransformation, using: CustomIntTransformation())
                        data["optionalDictionary"].map(&optionalDictionaryTransformation, using: CustomIntTransformation())
                        
                        expect((data as? SerializableMappableDataWrapper)?.delegate.data) == TestData.Map.nullType
                    }
                }
            }
            describe("map value or") {
                describe("mappable") {
                    it("sets data") {
                        let delegate = SerializableData(objectMapper: ObjectMapper())
                        var data: MappableData = SerializableMappableDataWrapper(delegate: delegate)
                        
                        var value: Int = 1
                        var array: [Int] = [1, 2]
                        var dictionary: [String: Int] = ["a": 1, "b": 2]
                        var optionalArray: [Int?] = [1, nil]
                        var optionalDictionary: [String: Int?] = ["a": 1, "b": nil]
                        
                        data["value"].map(&value, or: 0)
                        data["array"].map(&array, or: [0])
                        data["dictionary"].map(&dictionary, or: ["a": 0])
                        data["optionalArray"].map(&optionalArray, or: [0])
                        data["optionalDictionary"].map(&optionalDictionary, or: ["a": 0])
                        
                        expect((data as? SerializableMappableDataWrapper)?.delegate.data) == TestData.Map.validType
                    }
                }
                describe("using transformation") {
                    it("sets data") {
                        let delegate = SerializableData(objectMapper: ObjectMapper())
                        var data: MappableData = SerializableMappableDataWrapper(delegate: delegate)
                        
                        var valueTransformation: Int = 2
                        var arrayTransformation: [Int] = [2, 4]
                        var dictionaryTransformation: [String: Int] = ["a": 2, "b": 4]
                        var optionalArrayTransformation: [Int?] = [2, nil]
                        var optionalDictionaryTransformation: [String: Int?] = ["a": 2, "b": nil]
                        
                        data["value"].map(&valueTransformation, using: CustomIntTransformation(), or: 0)
                        data["array"].map(&arrayTransformation, using: CustomIntTransformation(),or: [0])
                        data["dictionary"].map(&dictionaryTransformation, using: CustomIntTransformation(), or: ["a": 0])
                        data["optionalArray"].map(&optionalArrayTransformation, using: CustomIntTransformation(), or: [0])
                        data["optionalDictionary"].map(&optionalDictionaryTransformation, using: CustomIntTransformation(), or: ["a": 0])
                        
                        expect((data as? SerializableMappableDataWrapper)?.delegate.data) == TestData.Map.validType
                    }
                }
            }
            describe("map throws") {
                describe("mappable") {
                    it("sets data") {
                        let delegate = SerializableData(objectMapper: ObjectMapper())
                        var data: MappableData = SerializableMappableDataWrapper(delegate: delegate)
                        
                        expect {
                            var value: Int = 1
                            var array: [Int] = [1, 2]
                            var dictionary: [String: Int] = ["a": 1, "b": 2]
                            var optionalArray: [Int?] = [1, nil]
                            var optionalDictionary: [String: Int?] = ["a": 1, "b": nil]
                            
                            try data["value"].map(&value)
                            try data["array"].map(&array)
                            try data["dictionary"].map(&dictionary)
                            try data["optionalArray"].map(&optionalArray)
                            try data["optionalDictionary"].map(&optionalDictionary)
                            
                            expect((data as? SerializableMappableDataWrapper)?.delegate.data) == TestData.Map.validType
                            
                            return 0
                            }.toNot(throwError())
                    }
                }
                describe("using transformation") {
                    it("sets data") {
                        let delegate = SerializableData(objectMapper: ObjectMapper())
                        var data: MappableData = SerializableMappableDataWrapper(delegate: delegate)
                        
                        expect {
                            var valueTransformation: Int = 2
                            var arrayTransformation: [Int] = [2, 4]
                            var dictionaryTransformation: [String: Int] = ["a": 2, "b": 4]
                            var optionalArrayTransformation: [Int?] = [2, nil]
                            var optionalDictionaryTransformation: [String: Int?] = ["a": 2, "b": nil]
                            
                            try data["value"].map(&valueTransformation, using: CustomIntTransformation())
                            try data["array"].map(&arrayTransformation, using: CustomIntTransformation())
                            try data["dictionary"].map(&dictionaryTransformation, using: CustomIntTransformation())
                            try data["optionalArray"].map(&optionalArrayTransformation, using: CustomIntTransformation())
                            try data["optionalDictionary"].map(&optionalDictionaryTransformation, using: CustomIntTransformation())
                            
                            expect((data as? SerializableMappableDataWrapper)?.delegate.data) == TestData.Map.validType
                            
                            return 0
                            }.toNot(throwError())
                    }
                }
            }
            describe("subscript") {
                let delegate = SerializableData(objectMapper: ObjectMapper(polymorph: StaticPolymorph()))
                var value: Int? = 1
                
                it("sets data with subData") {
                    var data = SerializableMappableDataWrapper(delegate: delegate)
                    
                    data["a"]["b"].map(&value)
                    
                    expect(data.delegate.data) == TestData.Map.pathType
                }
                it("accepts array") {
                    var data = SerializableMappableDataWrapper(delegate: delegate)
                    
                    data[["a", "b"]].map(&value)
                    
                    expect(data.delegate.data) == TestData.Map.pathType
                }
                it("accepts vararg") {
                    var data = SerializableMappableDataWrapper(delegate: delegate)
                    
                    data["a", "b"].map(&value)
                    
                    expect(data.delegate.data) == TestData.Map.pathType
                }
                it("passes correct ObjectMapper") {
                    var data = SerializableMappableDataWrapper(delegate: delegate)
                    
                    expect((data["a"] as? SerializableMappableDataWrapper)?.delegate.objectMapper) === data.delegate.objectMapper
                }
            }
        }
    }
}
