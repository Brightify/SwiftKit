//
//  BoolMappingOperatorsTest.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/07/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import SwiftKit
import SwiftyJSON
import Quick
import Nimble

class BoolMappingOperatorsTest: QuickSpec {
    
    override func spec() {
        describe("ObjectMapper Bool mapping operators") {
            let mapper = ObjectMapper()
            let map = BaseMap(objectMapper: mapper, mappingDirection: .toJSON)
            
            it("serializes Bool") {
                var falseBool: Bool = false
                var trueBool: Bool = true
                
                map["Bool(false)"].mapValueTo(field: &falseBool, transformWith: BoolTransformation())
                map["Bool(true)"].mapValueTo(field: &trueBool, transformWith: BoolTransformation())
                
                expect(map.json.unbox["Bool(false)"].bool).to(equal(false))
                expect(map.json.unbox["Bool(true)"].bool).to(equal(true))
            }
            
            it("serializes implicitly unwrapped Bool") {
                var nilBool: Bool! = nil
                var falseBool: Bool! = false
                var trueBool: Bool! = true
                
                map["Bool!(nil)"].mapValueTo(field: &nilBool, transformWith: BoolTransformation())
                map["Bool!(false)"].mapValueTo(field: &falseBool, transformWith: BoolTransformation())
                map["Bool!(true)"].mapValueTo(field: &trueBool, transformWith: BoolTransformation())
                
                expect(map.json.unbox["Bool!(nil)"].bool).to(beNil())
                expect(map.json.unbox["Bool!(false)"].bool).to(equal(false))
                expect(map.json.unbox["Bool!(true)"].bool).to(equal(true))
            }
            
            it("serializes optional Bool") {
                var nilBool: Bool? = nil
                var falseBool: Bool? = false
                var trueBool: Bool? = true
                
                map["Bool?(nil)"].mapValueTo(field: &nilBool, transformWith: BoolTransformation())
                map["Bool?(false)"].mapValueTo(field: &falseBool, transformWith: BoolTransformation())
                map["Bool?(true)"].mapValueTo(field: &trueBool, transformWith: BoolTransformation())
                
                expect(map.json.unbox["Bool?(nil)"].bool).to(beNil())
                expect(map.json.unbox["Bool?(false)"].bool).to(equal(false))
                expect(map.json.unbox["Bool?(true)"].bool).to(equal(true))
            }
            
            it("serializes Bool array") {
                var emptyBoolArray: [Bool] = []
                var boolArray: [Bool] = [true, false, true, false]
                
                map["[Bool]([])"].mapValueArrayTo(field: &emptyBoolArray, transformWith: BoolTransformation())
                map["[Bool]([true,false,true,false])"].mapValueArrayTo(field: &boolArray, transformWith: BoolTransformation())
                
                expect(map.json.unbox["[Bool]([])"].array).to(equal([]))
                expect(map.json.unbox["[Bool]([true,false,true,false])"].array) == [JSON(true), JSON(false), JSON(true), JSON(false)] as [JSON]
            }
            
            it("serializes String Bool dictionary") {
                var emptyBoolDictionary: [String: Bool] = [:]
                var boolDictionary: [String: Bool] = ["true": true, "false": false]
                
                map["[String:Bool]([:])"].mapValueDictionaryTo(field: &emptyBoolDictionary, transformWith: BoolTransformation())
                map["[String:Bool](['true':true,'false':false])"].mapValueDictionaryTo(field: &boolDictionary, transformWith: BoolTransformation())
                
                expect(map.json.unbox["[String:Bool]([:])"].dictionary).to(equal([:]))
                expect(map.json.unbox["[String:Bool](['true':true,'false':false])"].dictionary)
                    .to(equal(["true": JSON(true), "false": JSON(false)]))
            }
        }
    }
}
