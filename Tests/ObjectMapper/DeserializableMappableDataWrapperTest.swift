//
//  DeserializableMappableDataWrapperTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class DeserializableMappableDataWrapperTest: QuickSpec {
    
    private typealias CustomIntTransformation = TestData.CustomIntTransformation
    
    override func spec() {
        describe("DeserializableMappableDataWrapper") {
            describe("map optional") {
                it("puts data to value if type is valid") {
                    let delegate = DeserializableData(data: TestData.Map.validType, objectMapper: ObjectMapper())
                    var data: MappableData = DeserializableMappableDataWrapper(delegate: delegate)
                    
                    var value: Int?
                    var array: [Int]?
                    var dictionary: [String: Int]?
                    var optionalArray: [Int?]?
                    var optionalDictionary: [String: Int?]?
                    
                    var valueTransformation: Int?
                    var arrayTransformation: [Int]?
                    var dictionaryTransformation: [String: Int]?
                    var optionalArrayTransformation: [Int?]?
                    var optionalDictionaryTransformation: [String: Int?]?
                    
                    data["value"].map(&value)
                    data["array"].map(&array)
                    data["dictionary"].map(&dictionary)
                    data["optionalArray"].map(&optionalArray)
                    data["optionalDictionary"].map(&optionalDictionary)
                    
                    data["value"].map(&valueTransformation, using: CustomIntTransformation())
                    data["array"].map(&arrayTransformation, using: CustomIntTransformation())
                    data["dictionary"].map(&dictionaryTransformation, using: CustomIntTransformation())
                    data["optionalArray"].map(&optionalArrayTransformation, using: CustomIntTransformation())
                    data["optionalDictionary"].map(&optionalDictionaryTransformation, using: CustomIntTransformation())
                    
                    TestData.Map.assertValidType(value, array, dictionary, optionalArray, optionalDictionary)
                    
                    TestData.Map.assertValidTypeUsingTransformation(valueTransformation, arrayTransformation,
                                                                    dictionaryTransformation, optionalArrayTransformation, optionalDictionaryTransformation)
                }
                it("puts nil to value if type is not valid") {
                    let delegate = DeserializableData(data: TestData.Map.invalidType, objectMapper: ObjectMapper())
                    var data: MappableData = DeserializableMappableDataWrapper(delegate: delegate)
                    
                    var value: Int?
                    var array: [Int]?
                    var dictionary: [String: Int]?
                    var optionalArray: [Int?]?
                    var optionalDictionary: [String: Int?]?
                    
                    var valueTransformation: Int?
                    var arrayTransformation: [Int]?
                    var dictionaryTransformation: [String: Int]?
                    var optionalArrayTransformation: [Int?]?
                    var optionalDictionaryTransformation: [String: Int?]?
                    
                    data["value"].map(&value)
                    data["array"].map(&array)
                    data["dictionary"].map(&dictionary)
                    data["optionalArray"].map(&optionalArray)
                    data["optionalDictionary"].map(&optionalDictionary)
                    
                    data["value"].map(&valueTransformation, using: CustomIntTransformation())
                    data["array"].map(&arrayTransformation, using: CustomIntTransformation())
                    data["dictionary"].map(&dictionaryTransformation, using: CustomIntTransformation())
                    data["optionalArray"].map(&optionalArrayTransformation, using: CustomIntTransformation())
                    data["optionalDictionary"].map(&optionalDictionaryTransformation, using: CustomIntTransformation())
                    
                    TestData.Map.assertInvalidType(value, array, dictionary, optionalArray, optionalDictionary)
                    
                    TestData.Map.assertInvalidType(valueTransformation, arrayTransformation,
                                                   dictionaryTransformation, optionalArrayTransformation, optionalDictionaryTransformation)
                }
            }
            describe("map value or") {
                it("puts data to value if type is valid") {
                    let delegate = DeserializableData(data: TestData.Map.validType, objectMapper: ObjectMapper())
                    var data: MappableData = DeserializableMappableDataWrapper(delegate: delegate)
                    
                    var value: Int = -1
                    var array: [Int] = []
                    var dictionary: [String: Int] = [:]
                    var optionalArray: [Int?] = []
                    var optionalDictionary: [String: Int?] = [:]
                    
                    var valueTransformation: Int = -1
                    var arrayTransformation: [Int] = []
                    var dictionaryTransformation: [String: Int] = [:]
                    var optionalArrayTransformation: [Int?] = []
                    var optionalDictionaryTransformation: [String: Int?] = [:]
                    
                    data["value"].map(&value, or: 0)
                    data["array"].map(&array, or: [0])
                    data["dictionary"].map(&dictionary, or: ["a": 0])
                    data["optionalArray"].map(&optionalArray, or: [0])
                    data["optionalDictionary"].map(&optionalDictionary, or: ["a": 0])
                    
                    data["value"].map(&valueTransformation, using: CustomIntTransformation(), or: 0)
                    data["array"].map(&arrayTransformation, using: CustomIntTransformation(),or: [0])
                    data["dictionary"].map(&dictionaryTransformation, using: CustomIntTransformation(), or: ["a": 0])
                    data["optionalArray"].map(&optionalArrayTransformation, using: CustomIntTransformation(), or: [0])
                    data["optionalDictionary"].map(&optionalDictionaryTransformation, using: CustomIntTransformation(), or: ["a": 0])

                    TestData.Map.assertValidType(value, array, dictionary, optionalArray, optionalDictionary)
                    
                    TestData.Map.assertValidTypeUsingTransformation(valueTransformation, arrayTransformation,
                                                                    dictionaryTransformation, optionalArrayTransformation, optionalDictionaryTransformation)
                }
                it("puts defaultValue to value if type is not valid") {
                    let delegate = DeserializableData(data: TestData.Map.invalidType, objectMapper: ObjectMapper())
                    var data: MappableData = DeserializableMappableDataWrapper(delegate: delegate)
                    
                    var value: Int = -1
                    var array: [Int] = []
                    var dictionary: [String: Int] = [:]
                    var optionalArray: [Int?] = []
                    var optionalDictionary: [String: Int?] = [:]
                    
                    var valueTransformation: Int = -1
                    var arrayTransformation: [Int] = []
                    var dictionaryTransformation: [String: Int] = [:]
                    var optionalArrayTransformation: [Int?] = []
                    var optionalDictionaryTransformation: [String: Int?] = [:]
                    
                    data["value"].map(&value, or: 0)
                    data["array"].map(&array, or: [0])
                    data["dictionary"].map(&dictionary, or: ["a": 0])
                    data["optionalArray"].map(&optionalArray, or: [0])
                    data["optionalDictionary"].map(&optionalDictionary, or: ["a": 0])
                    
                    data["value"].map(&valueTransformation, using: CustomIntTransformation(), or: 0)
                    data["array"].map(&arrayTransformation, using: CustomIntTransformation(),or: [0])
                    data["dictionary"].map(&dictionaryTransformation, using: CustomIntTransformation(), or: ["a": 0])
                    data["optionalArray"].map(&optionalArrayTransformation, using: CustomIntTransformation(), or: [0])
                    data["optionalDictionary"].map(&optionalDictionaryTransformation, using: CustomIntTransformation(), or: ["a": 0])

                    TestData.Map.assertInvalidTypeOr(value, array, dictionary, optionalArray, optionalDictionary)
                    
                    TestData.Map.assertInvalidTypeOr(valueTransformation, arrayTransformation,
                                                     dictionaryTransformation, optionalArrayTransformation, optionalDictionaryTransformation)
                }
            }
            describe("map throws") {
                it("puts data to value if type is valid") {
                    let delegate = DeserializableData(data: TestData.Map.validType, objectMapper: ObjectMapper())
                    var data: MappableData = DeserializableMappableDataWrapper(delegate: delegate)
                    
                    expect {
                        var value: Int = -1
                        var array: [Int] = []
                        var dictionary: [String: Int] = [:]
                        var optionalArray: [Int?] = []
                        var optionalDictionary: [String: Int?] = [:]
                        
                        var valueTransformation: Int = -1
                        var arrayTransformation: [Int] = []
                        var dictionaryTransformation: [String: Int] = [:]
                        var optionalArrayTransformation: [Int?] = []
                        var optionalDictionaryTransformation: [String: Int?] = [:]
                        
                        try data["value"].map(&value)
                        try data["array"].map(&array)
                        try data["dictionary"].map(&dictionary)
                        try data["optionalArray"].map(&optionalArray)
                        try data["optionalDictionary"].map(&optionalDictionary)
                        
                        try data["value"].map(&valueTransformation, using: CustomIntTransformation())
                        try data["array"].map(&arrayTransformation, using: CustomIntTransformation())
                        try data["dictionary"].map(&dictionaryTransformation, using: CustomIntTransformation())
                        try data["optionalArray"].map(&optionalArrayTransformation, using: CustomIntTransformation())
                        try data["optionalDictionary"].map(&optionalDictionaryTransformation, using: CustomIntTransformation())
                        
                        TestData.Map.assertValidType(value, array, dictionary, optionalArray, optionalDictionary)
                        
                        TestData.Map.assertValidTypeUsingTransformation(valueTransformation, arrayTransformation,
                                                                        dictionaryTransformation, optionalArrayTransformation, optionalDictionaryTransformation)
                        
                        return 0
                        }.toNot(throwError())
                    
                }
                it("throws error if type is not valid") {
                    let delegate = DeserializableData(data: TestData.Map.invalidType, objectMapper: ObjectMapper())
                    var data: MappableData = DeserializableMappableDataWrapper(delegate: delegate)
                    
                    var value: Int = -1
                    var array: [Int] = []
                    var dictionary: [String: Int] = [:]
                    var optionalArray: [Int?] = []
                    var optionalDictionary: [String: Int?] = [:]
                    
                    var valueTransformation: Int = -1
                    var arrayTransformation: [Int] = []
                    var dictionaryTransformation: [String: Int] = [:]
                    var optionalArrayTransformation: [Int?] = []
                    var optionalDictionaryTransformation: [String: Int?] = [:]
                    
                    expect { try data["value"].map(&value) }.to(throwError())
                    expect { try data["array"].map(&array) }.to(throwError())
                    expect { try data["dictionary"].map(&dictionary) }.to(throwError())
                    expect { try data["optionalArray"].map(&optionalArray) }.to(throwError())
                    expect { try data["optionalDictionary"].map(&optionalDictionary) }.to(throwError())
                    
                    expect { try data["value"].map(&valueTransformation, using: CustomIntTransformation()) }.to(throwError())
                    expect { try data["array"].map(&arrayTransformation, using: CustomIntTransformation()) }.to(throwError())
                    expect { try data["dictionary"].map(&dictionaryTransformation, using: CustomIntTransformation()) }.to(throwError())
                    expect { try data["optionalArray"].map(&optionalArrayTransformation, using: CustomIntTransformation()) }.to(throwError())
                    expect { try data["optionalDictionary"].map(&optionalDictionaryTransformation, using: CustomIntTransformation()) }.to(throwError())
                }
            }
            describe("subscript") {
                let delegate = DeserializableData(data: TestData.Map.pathType, objectMapper: ObjectMapper(polymorph: StaticPolymorph()))
                let data = DeserializableMappableDataWrapper(delegate: delegate)
                it("returns DeserializableMappableDataWrapper with subData if path exists") {
                    expect((data["a"]["b"] as? DeserializableMappableDataWrapper)?.delegate.raw) == SupportedType.int(1)
                }
                it("returns DeserializableMappableDataWrapper with .null if path does not exist") {
                    expect((data["b"] as? DeserializableMappableDataWrapper)?.delegate.raw) == SupportedType.null
                }
                it("accepts array") {
                    expect((data[["a", "b"]] as? DeserializableMappableDataWrapper)?.delegate.raw) == SupportedType.int(1)
                }
                it("accepts vararg") {
                    expect((data["a", "b"] as? DeserializableMappableDataWrapper)?.delegate.raw) == SupportedType.int(1)
                }
                it("passes correct ObjectMapper") {
                    expect((data["a"] as? DeserializableMappableDataWrapper)?.delegate.objectMapper) === data.delegate.objectMapper
                }
            }
        }
    }
}
