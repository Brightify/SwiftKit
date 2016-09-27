//
//  ObjectMapperPolymorphismTest.swift
//  SwiftKit
//
//  Created by Tadeáš Kříž on 6/29/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class ObjectMapperPolymorphismTest: QuickSpec {

    override func spec() {
        describe("ObjectMapper polymorphism") {
            let objectMapper = ObjectMapper()
            it("serializes objects") {
                let object1 = ChildADTO()
                let object2 = ChildBDTO()
                let object3 = ChildB2DTO()
                
                let objectArray = [object1, object2, object3]
                let json = objectMapper.toJSONArray(objectArray)
                debugPrint(json)
                
                
            }
            
            it("deserializes previously serialized objects") {
                let object1 = ChildADTO()
                var subMappable = SubMappable()
                subMappable.test = "Hello!!!"
                object1.subData = subMappable
                let object2 = ChildBDTO()
                let object3 = ChildB2DTO()
                
                let objectArray = [object1, object2, object3]
                let json = objectMapper.toJSONArray(objectArray)
                
                debugPrint(json)
                
                let deserializedObjects: [ParentDTO]? = objectMapper.mapArray(json)
                
                expect(deserializedObjects).toNot(beNil())
                expect(deserializedObjects!.count) == 3
            }
        }
    }
}

struct SubMappable: Mappable {
    
    var test: String = ""
    
    init?(_ map: Map) {
        mapping(map)
    }
    
    init() {}
    
    mutating func mapping(_ map: Map) {
        map["testData"].mapValueTo(field: &test, transformWith: StringTransformation())
    }
    
}

class ParentDTO: PolymorphicMappable {
    
    var subData: SubMappable?
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    init() { }
    
    func mapping(_ map: Map) {
        map["submappable"].mapObjectTo(field: &subData)
    }
    
    class func jsonTypeInfo() -> JsonTypeInfo {
        let builder = JsonTypeInfoBuilder<ParentDTO>()
        builder.registerSubtype(ChildADTO.self, named: "ChildADTO")
        builder.registerSubtype(ChildBDTO.self, named: "VeryRandomName")
        return builder.build()
    }
}

class ChildADTO: ParentDTO {
    
}

class ChildBDTO: ParentDTO {
    override class func jsonTypeInfo() -> JsonTypeInfo {
        let builder = JsonTypeInfoBuilder<ChildBDTO>()
        builder.registerSubtype(ChildB2DTO.self, named: "ChildB2DTO")
        return builder.build()
    }
}

class ChildB2DTO: ChildBDTO {
    
}

