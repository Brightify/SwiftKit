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
            let map = BaseMap(objectMapper: mapper, mappingDirection: .ToJSON)
            
            it("serializes Bool") {
                var falseBool: Bool = false
                var trueBool: Bool = true
                
                falseBool <- map["Bool(false)"]
                trueBool <- map["Bool(true)"]
                
                expect(map.json.unbox["Bool(false)"].bool).to(equal(false))
                expect(map.json.unbox["Bool(true)"].bool).to(equal(true))
            }
            
            it("serializes implicitly unwrapped Bool") {
                var nilBool: Bool! = nil
                var falseBool: Bool! = false
                var trueBool: Bool! = true
                
                nilBool <- map["Bool!(nil)"]
                falseBool <- map["Bool!(false)"]
                trueBool <- map["Bool!(true)"]
                
                expect(map.json.unbox["Bool!(nil)"].bool).to(beNil())
                expect(map.json.unbox["Bool!(false)"].bool).to(equal(false))
                expect(map.json.unbox["Bool!(true)"].bool).to(equal(true))
            }
            
            it("serializes optional Bool") {
                var nilBool: Bool? = nil
                var falseBool: Bool? = false
                var trueBool: Bool? = true
                
                nilBool <- map["Bool?(nil)"]
                falseBool <- map["Bool?(false)"]
                trueBool <- map["Bool?(true)"]
                
                expect(map.json.unbox["Bool?(nil)"].bool).to(beNil())
                expect(map.json.unbox["Bool?(false)"].bool).to(equal(false))
                expect(map.json.unbox["Bool?(true)"].bool).to(equal(true))
            }
            
            it("serializes Bool array") {
                var emptyBoolArray: [Bool] = []
                var boolArray: [Bool] = [true, false, true, false]
                
                emptyBoolArray <- map["[Bool]([])"]
                boolArray <- map["[Bool]([true,false,true,false])"]
                
                expect(map.json.unbox["[Bool]([])"].array).to(equal([]))
                expect(map.json.unbox["[Bool]([true,false,true,false])"].array)
                    .to(equal([JSON(true), JSON(false), JSON(true), JSON(false)]))
            }
            
            it("serializes String Bool dictionary") {
                var emptyBoolDictionary: [String: Bool] = [:]
                var boolDictionary: [String: Bool] = ["true": true, "false": false]
                
                emptyBoolDictionary <- map["[String:Bool]([:])"]
                boolDictionary <- map["[String:Bool](['true':true,'false':false])"]
                
                expect(map.json.unbox["[String:Bool]([:])"].dictionary).to(equal([:]))
                expect(map.json.unbox["[String:Bool](['true':true,'false':false])"].dictionary)
                    .to(equal(["true": JSON(true), "false": JSON(false)]))
            }
        }
    }
}
