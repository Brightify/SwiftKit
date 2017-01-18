//
//  DeserializableDataTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class DeserializableDataTest: QuickSpec {
    
    private typealias CustomIntTransformation = TestData.CustomIntTransformation
    
    override func spec() {
        describe("DeserializableData") {
            describe("get optional") {
                it("returns data if type is valid") {
                    let data = DeserializableData(data: TestData.Map.validType, objectMapper: ObjectMapper())
                    
                    let value: Int? = data["value"].get()
                    let array: [Int]? = data["array"].get()
                    let dictionary: [String: Int]? = data["dictionary"].get()
                    let optionalArray: [Int?]? = data["optionalArray"].get()
                    let optionalDictionary: [String: Int?]? = data["optionalDictionary"].get()
                    
                    let valueTransformation: Int? = data["value"].get(using: CustomIntTransformation())
                    let arrayTransformation: [Int]? = data["array"].get(using: CustomIntTransformation())
                    let dictionaryTransformation: [String: Int]? = data["dictionary"].get(using: CustomIntTransformation())
                    let optionalArrayTransformation: [Int?]? = data["optionalArray"].get(using: CustomIntTransformation())
                    let optionalDictionaryTransformation: [String: Int?]? = data["optionalDictionary"].get(using: CustomIntTransformation())
                    
                    TestData.Map.assertValidType(value, array, dictionary, optionalArray, optionalDictionary)
                    
                    TestData.Map.assertValidTypeUsingTransformation(valueTransformation, arrayTransformation,
                                                                    dictionaryTransformation, optionalArrayTransformation, optionalDictionaryTransformation)
                }
                it("returns nil if type is not valid") {
                    let data = DeserializableData(data: TestData.Map.invalidType, objectMapper: ObjectMapper())
                    
                    let value: Int? = data["value"].get()
                    let array: [Int]? = data["array"].get()
                    let dictionary: [String: Int]? = data["dictionary"].get()
                    let optionalArray: [Int?]? = data["optionalArray"].get()
                    let optionalDictionary: [String: Int?]? = data["optionalDictionary"].get()
                    
                    let valueTransformation: Int? = data["value"].get(using: CustomIntTransformation())
                    let arrayTransformation: [Int]? = data["array"].get(using: CustomIntTransformation())
                    let dictionaryTransformation: [String: Int]? = data["dictionary"].get(using: CustomIntTransformation())
                    let optionalArrayTransformation: [Int?]? = data["optionalArray"].get(using: CustomIntTransformation())
                    let optionalDictionaryTransformation: [String: Int?]? = data["optionalDictionary"].get(using: CustomIntTransformation())
                    
                    TestData.Map.assertInvalidType(value, array, dictionary, optionalArray, optionalDictionary)
                    
                    TestData.Map.assertInvalidType(valueTransformation, arrayTransformation,
                                                                    dictionaryTransformation, optionalArrayTransformation, optionalDictionaryTransformation)
                }
            }
            describe("get value or") {
                it("returns data if type is valid") {
                    let data = DeserializableData(data: TestData.Map.validType, objectMapper: ObjectMapper())
                    
                    let value: Int = data["value"].get(or: 0)
                    let array: [Int] = data["array"].get(or: [0])
                    let dictionary: [String: Int] = data["dictionary"].get(or: ["a": 0])
                    let optionalArray: [Int?] = data["optionalArray"].get(or: [0])
                    let optionalDictionary: [String: Int?] = data["optionalDictionary"].get(or: ["a": 0])
                    
                    let valueTransformation: Int = data["value"].get(using: CustomIntTransformation(), or: 0)
                    let arrayTransformation: [Int] = data["array"].get(using: CustomIntTransformation(), or: [0])
                    let dictionaryTransformation: [String: Int] = data["dictionary"].get(using: CustomIntTransformation(), or: ["a": 0])
                    let optionalArrayTransformation: [Int?] = data["optionalArray"].get(using: CustomIntTransformation(), or: [0])
                    let optionalDictionaryTransformation: [String: Int?] = data["optionalDictionary"].get(using: CustomIntTransformation(), or: ["a": 0])
                    
                    TestData.Map.assertValidType(value, array, dictionary, optionalArray, optionalDictionary)
                    
                    TestData.Map.assertValidTypeUsingTransformation(valueTransformation, arrayTransformation,
                                                                    dictionaryTransformation, optionalArrayTransformation, optionalDictionaryTransformation)
                }
                it("returns defaultValue if type is not valid") {
                    let data = DeserializableData(data: TestData.Map.invalidType, objectMapper: ObjectMapper())
                    
                    let value: Int = data["value"].get(or: 0)
                    let array: [Int] = data["array"].get(or: [0])
                    let dictionary: [String: Int] = data["dictionary"].get(or: ["a": 0])
                    let optionalArray: [Int?] = data["optionalArray"].get(or: [0])
                    let optionalDictionary: [String: Int?] = data["optionalDictionary"].get(or: ["a": 0])
                    
                    let valueTransformation: Int = data["value"].get(using: CustomIntTransformation(), or: 0)
                    let arrayTransformation: [Int] = data["array"].get(using: CustomIntTransformation(), or: [0])
                    let dictionaryTransformation: [String: Int] = data["dictionary"].get(using: CustomIntTransformation(), or: ["a": 0])
                    let optionalArrayTransformation: [Int?] = data["optionalArray"].get(using: CustomIntTransformation(), or: [0])
                    let optionalDictionaryTransformation: [String: Int?] = data["optionalDictionary"].get(using: CustomIntTransformation(), or: ["a": 0])
                    
                    expect(value) == 0
                    expect(array) == [0]
                    expect(dictionary) == ["a": 0]
                    expect(areEqual(optionalArray, [0])).to(beTrue())
                    expect(areEqual(optionalDictionary, ["a": 0])).to(beTrue())
                    
                    expect(valueTransformation) == 0
                    expect(arrayTransformation) == [0]
                    expect(dictionaryTransformation) == ["a": 0]
                    expect(areEqual(optionalArrayTransformation, [0])).to(beTrue())
                    expect(areEqual(optionalDictionaryTransformation, ["a": 0])).to(beTrue())
                    
                    TestData.Map.assertInvalidTypeOr(value, array, dictionary, optionalArray, optionalDictionary)
                    
                    TestData.Map.assertInvalidTypeOr(valueTransformation, arrayTransformation,
                                                   dictionaryTransformation, optionalArrayTransformation, optionalDictionaryTransformation)
                }
            }
            describe("get throws") {
                it("returns data if type is valid") {
                    let data = DeserializableData(data: TestData.Map.validType, objectMapper: ObjectMapper())
                    
                    expect {
                        let value: Int = try data["value"].get()
                        let array: [Int] = try data["array"].get()
                        let dictionary: [String: Int] = try data["dictionary"].get()
                        let optionalArray: [Int?] = try data["optionalArray"].get()
                        let optionalDictionary: [String: Int?] = try data["optionalDictionary"].get()
                        
                        let valueTransformation: Int = try data["value"].get(using: CustomIntTransformation())
                        let arrayTransformation: [Int] = try data["array"].get(using: CustomIntTransformation())
                        let dictionaryTransformation: [String: Int] = try data["dictionary"].get(using: CustomIntTransformation())
                        let optionalArrayTransformation: [Int?] = try data["optionalArray"].get(using: CustomIntTransformation())
                        let optionalDictionaryTransformation: [String: Int?] = try data["optionalDictionary"].get(using: CustomIntTransformation())
                        
                        TestData.Map.assertValidType(value, array, dictionary, optionalArray, optionalDictionary)
                        
                        TestData.Map.assertValidTypeUsingTransformation(valueTransformation, arrayTransformation,
                                                                        dictionaryTransformation, optionalArrayTransformation, optionalDictionaryTransformation)
                        
                        return 0
                    }.toNot(throwError())
                }
                it("throws error if type is not valid") {
                    let data = DeserializableData(data: TestData.Map.invalidType, objectMapper: ObjectMapper())

                    expect { let _: Int = try data["value"].get(); return 0 }.to(throwError())
                    expect { let _: [Int] = try data["array"].get(); return 0 }.to(throwError())
                    expect { let _: [String: Int] = try data["dictionary"].get(); return 0 }.to(throwError())
                    expect { let _: [Int?] = try data["optionalArray"].get(); return 0 }.to(throwError())
                    expect { let _: [String: Int?] = try data["optionalDictionary"].get(); return 0 }.to(throwError())
                        
                    expect { let _: Int = try data["value"].get(using: CustomIntTransformation()); return 0 }.to(throwError())
                    expect { let _: [Int] = try data["array"].get(using: CustomIntTransformation()); return 0 }.to(throwError())
                    expect { let _: [String: Int] = try data["dictionary"].get(using: CustomIntTransformation()); return 0 }.to(throwError())
                    expect { let _: [Int?] = try data["optionalArray"].get(using: CustomIntTransformation()); return 0 }.to(throwError())
                    expect { let _: [String: Int?] = try data["optionalDictionary"].get(using: CustomIntTransformation()); return 0 }.to(throwError())
                }
            }
            describe("subscript") {
                let data = DeserializableData(data: TestData.Map.pathType, objectMapper: ObjectMapper(polymorph: StaticPolymorph()))
                it("returns DeserializableData with subData if path exists") {
                    expect(data["a"]["b"].raw) == SupportedType.int(1)
                }
                it("returns DeserializableData with .null if path does not exist") {
                    expect(data["b"].raw) == SupportedType.null
                }
                it("accepts array") {
                    expect(data[["a", "b"]].raw) == SupportedType.int(1)
                }
                it("accepts vararg") {
                    expect(data["a", "b"].raw) == SupportedType.int(1)
                }
                it("passes correct ObjectMapper") {
                    expect(data["a"].objectMapper) === data.objectMapper
                }
            }
            describe("valueOrThrow") {
                let data = DeserializableData(data: .null, objectMapper: ObjectMapper())
                it("returns value if value is present") {
                    let x: Int? = 1
                    
                    expect(try? data.valueOrThrow(x)).toNot(beNil())
                }
                it("throws error if value is nil") {
                    let x: Int? = nil
                    
                    expect { try data.valueOrThrow(x) }.to(throwError())
                }
            }
        }
    }
}
