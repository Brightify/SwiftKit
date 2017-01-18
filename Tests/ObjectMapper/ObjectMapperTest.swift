//
//  ObjectMapperTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class ObjectMapperTest: QuickSpec {
    
    private typealias CustomIntTransformation = TestData.CustomIntTransformation
    private typealias A = TestData.PolymorphicTypes.A
    private typealias B = TestData.PolymorphicTypes.B
    private typealias C = TestData.PolymorphicTypes.C
    
    override func spec() {
        describe("ObjectMapper") {
            
            it("serializes and deserializes to the same object") {
                let objectMapper = ObjectMapper()
                let object = TestData.generate(x: 3)
                
                let result: TestData.MappableStruct? = objectMapper.deserialize(objectMapper.serialize(object))
                
                expect(result) == object
            }
            context("with polymorph") {
                let objectMapper = ObjectMapper(polymorph: StaticPolymorph())
                
                describe("serialize") {
                    context("not polymorphic type") {
                        it("returns serialized data if type is valid") {
                            let value: Int? = 1
                            let array: [Int]? = [1, 2]
                            let dictionary: [String: Int]? = ["a": 1, "b": 2]
                            let optionalArray: [Int?]? = [1, nil]
                            let optionalDictionary: [String: Int?]? = ["a": 1, "b": nil]
                            
                            let valueTransformation: Int? = 2
                            let arrayTransformation: [Int]? = [2, 4]
                            let dictionaryTransformation: [String: Int]? = ["a": 2, "b": 4]
                            let optionalArrayTransformation: [Int?]? = [2, nil]
                            let optionalDictionaryTransformation: [String: Int?]? = ["a": 2, "b": nil]
                            
                            expect(objectMapper.serialize(value)) == self.getValidType("value")
                            expect(objectMapper.serialize(array)) == self.getValidType("array")
                            expect(objectMapper.serialize(dictionary)) == self.getValidType("dictionary")
                            expect(objectMapper.serialize(optionalArray)) == self.getValidType("optionalArray")
                            expect(objectMapper.serialize(optionalDictionary)) == self.getValidType("optionalDictionary")
                            
                            expect(objectMapper.serialize(valueTransformation, using: CustomIntTransformation())) == self.getValidType("value")
                            expect(objectMapper.serialize(arrayTransformation, using: CustomIntTransformation())) == self.getValidType("array")
                            expect(objectMapper.serialize(dictionaryTransformation, using: CustomIntTransformation())) == self.getValidType("dictionary")
                            expect(objectMapper.serialize(optionalArrayTransformation, using: CustomIntTransformation())) == self.getValidType("optionalArray")
                            expect(objectMapper.serialize(optionalDictionaryTransformation, using: CustomIntTransformation())) == self.getValidType("optionalDictionary")
                        }
                        it("returns nil if type is invalid") {
                            let value: Int? = nil
                            let array: [Int]? = nil
                            let dictionary: [String: Int]? = nil
                            let optionalArray: [Int?]? = nil
                            let optionalDictionary: [String: Int?]? = nil
                            
                            expect(objectMapper.serialize(value)) == SupportedType.null
                            expect(objectMapper.serialize(array)) == SupportedType.null
                            expect(objectMapper.serialize(dictionary)) == SupportedType.null
                            expect(objectMapper.serialize(optionalArray)) == SupportedType.null
                            expect(objectMapper.serialize(optionalDictionary)) == SupportedType.null
                            
                            expect(objectMapper.serialize(value, using: CustomIntTransformation())) == SupportedType.null
                            expect(objectMapper.serialize(array, using: CustomIntTransformation())) == SupportedType.null
                            expect(objectMapper.serialize(dictionary, using: CustomIntTransformation())) == SupportedType.null
                            expect(objectMapper.serialize(optionalArray, using: CustomIntTransformation())) == SupportedType.null
                            expect(objectMapper.serialize(optionalDictionary, using: CustomIntTransformation())) == SupportedType.null
                        }
                    }
                    context("polymorphic type") {
                        it("serializes data and writes type info") {
                            expect(objectMapper.serialize(TestData.PolymorphicTypes.a)) == TestData.PolymorphicTypes.aType
                            expect(objectMapper.serialize(TestData.PolymorphicTypes.b)) == TestData.PolymorphicTypes.bType
                            expect(objectMapper.serialize(TestData.PolymorphicTypes.c)) == TestData.PolymorphicTypes.cType
                        }
                    }
                }
                describe("deserialize") {
                    context("not polymorphic type") {
                        it("returns data if type is valid") {                            
                            let value: Int? = objectMapper.deserialize(self.getValidType("value"))
                            let array: [Int]? = objectMapper.deserialize(self.getValidType("array"))
                            let dictionary: [String: Int]? = objectMapper.deserialize(self.getValidType("dictionary"))
                            let optionalArray: [Int?]? = objectMapper.deserialize(self.getValidType("optionalArray"))
                            let optionalDictionary: [String: Int?]? = objectMapper.deserialize(self.getValidType("optionalDictionary"))
                            
                            let valueTransformation: Int? = objectMapper.deserialize(self.getValidType("value"), using: CustomIntTransformation())
                            let arrayTransformation: [Int]? = objectMapper.deserialize(self.getValidType("array"), using: CustomIntTransformation())
                            let dictionaryTransformation: [String: Int]? = objectMapper.deserialize(self.getValidType("dictionary"), using: CustomIntTransformation())
                            let optionalArrayTransformation: [Int?]? = objectMapper.deserialize(self.getValidType("optionalArray"), using: CustomIntTransformation())
                            let optionalDictionaryTransformation: [String: Int?]? = objectMapper.deserialize(self.getValidType("optionalDictionary"), using: CustomIntTransformation())
                            
                            TestData.Map.assertValidType(value, array, dictionary, optionalArray, optionalDictionary)
                            
                            TestData.Map.assertValidTypeUsingTransformation(valueTransformation, arrayTransformation,
                                                                            dictionaryTransformation, optionalArrayTransformation, optionalDictionaryTransformation)
                        }
                        it("returns nil if type is not valid") {
                            let value: Int? = objectMapper.deserialize(self.getInvalidType("value"))
                            let array: [Int]? = objectMapper.deserialize(self.getInvalidType("array"))
                            let dictionary: [String: Int]? = objectMapper.deserialize(self.getInvalidType("dictionary"))
                            let optionalArray: [Int?]? = objectMapper.deserialize(self.getInvalidType("optionalArray"))
                            let optionalDictionary: [String: Int?]? = objectMapper.deserialize(self.getInvalidType("optionalDictionary"))
                            
                            let valueTransformation: Int? = objectMapper.deserialize(self.getInvalidType("value"), using: CustomIntTransformation())
                            let arrayTransformation: [Int]? = objectMapper.deserialize(self.getInvalidType("array"), using: CustomIntTransformation())
                            let dictionaryTransformation: [String: Int]? = objectMapper.deserialize(self.getInvalidType("dictionary"), using: CustomIntTransformation())
                            let optionalArrayTransformation: [Int?]? = objectMapper.deserialize(self.getInvalidType("optionalArray"), using: CustomIntTransformation())
                            let optionalDictionaryTransformation: [String: Int?]? = objectMapper.deserialize(self.getInvalidType("optionalDictionary"), using: CustomIntTransformation())
                            
                            TestData.Map.assertInvalidType(value, array, dictionary, optionalArray, optionalDictionary)
                            
                            TestData.Map.assertInvalidType(valueTransformation, arrayTransformation,
                                                                            dictionaryTransformation, optionalArrayTransformation, optionalDictionaryTransformation)
                        }
                    }
                    context("polymorphic type") {
                        it("deserializes data with correct type") {
                            let a: A? = objectMapper.deserialize(TestData.PolymorphicTypes.aType)
                            let b: A? = objectMapper.deserialize(TestData.PolymorphicTypes.bType)
                            let c: A? = objectMapper.deserialize(TestData.PolymorphicTypes.cType)
                            
                            if let a = a, let b = b as? B, let c = c as? C {
                                expect(a.id) == TestData.PolymorphicTypes.a.id
                                
                                expect(b.id) == TestData.PolymorphicTypes.b.id
                                expect(b.name) == TestData.PolymorphicTypes.b.name
                                
                                expect(c.id) == TestData.PolymorphicTypes.c.id
                                expect(c.number) == TestData.PolymorphicTypes.c.number
                            } else {
                                expect(a).toNot(beNil())
                                expect(b).toNot(beNil())
                                expect(c).toNot(beNil())
                                
                                expect(b).to(beAKindOf(B.self))
                                expect(c).to(beAKindOf(C.self))
                            }
                        }
                    }
                }
            }
            context("without polymorph") {
                let objectMapper = ObjectMapper()
                
                describe("serialize") {
                    it("serializes polymorhic type like not polymorphic") {
                        expect(objectMapper.serialize(TestData.PolymorphicTypes.a)) == TestData.PolymorphicTypes.aTypeWithoutPolymorphicData
                        expect(objectMapper.serialize(TestData.PolymorphicTypes.b)) == TestData.PolymorphicTypes.bTypeWithoutPolymorphicData
                        expect(objectMapper.serialize(TestData.PolymorphicTypes.c)) == TestData.PolymorphicTypes.cTypeWithoutPolymorphicData
                    }
                }
                describe("deserialize") {
                    it("deserializes polymorhic type like not polymorphic") {
                        let a: A? = objectMapper.deserialize(TestData.PolymorphicTypes.aType)
                        let b: A? = objectMapper.deserialize(TestData.PolymorphicTypes.bType)
                        let c: A? = objectMapper.deserialize(TestData.PolymorphicTypes.cType)
                        
                        expect(a).toNot(beNil())
                        expect(b).toNot(beNil())
                        expect(c).toNot(beNil())
                        
                        expect(b).toNot(beAKindOf(B.self))
                        expect(c).toNot(beAKindOf(C.self))
                        
                        expect(a?.id) == TestData.PolymorphicTypes.a.id
                        expect(b?.id) == TestData.PolymorphicTypes.b.id
                        expect(c?.id) == TestData.PolymorphicTypes.c.id
                    }
                }
            }
        }
    }
    
    private func getValidType(_ key: String) -> SupportedType {
        return TestData.Map.validType.dictionary?[key] ?? SupportedType.null
    }
    
    private func getInvalidType(_ key: String) -> SupportedType {
        return TestData.Map.invalidType.dictionary?[key] ?? SupportedType.null
    }
}
