//
//  ObjectMapperTest.swift
//  SwiftKit
//
//  Created by Tadeáš Kříž on 6/26/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import SwiftKit
import Quick
import Nimble

class ObjectMapperTest: QuickSpec {
    
    override func spec() {
        describe("ObjectMapper") {
            let objectMapper = ObjectMapper()
            
            it("serializes struct") {
                let testObject = createTestStruct()
                
                var json = objectMapper.toJSON(testObject)
            
                expect(json["nsnumber"].numberValue) == testObject.nsnumber
                expect(json["optionalNsnumber"].number) == testObject.optionalNsnumber
                expect(json["unwrappedNsnumber"].number) == testObject.unwrappedNsnumber
                
                expect(json["bool"].boolValue) == testObject.bool
                expect(json["optionalBool"].bool) == testObject.optionalBool
                expect(json["unwrappedBool"].bool) == testObject.unwrappedBool
                
                expect(json["int"].intValue) == testObject.int
                expect(json["optionalInt"].int) == testObject.optionalInt
                expect(json["unwrappedInt"].int) == testObject.unwrappedInt
                
                expect(json["double"].doubleValue) == testObject.double
                expect(json["optionalDouble"].double) == testObject.optionalDouble
                expect(json["unwrappedDouble"].double) == testObject.unwrappedDouble
                
                expect(json["float"].floatValue) == testObject.float
                expect(json["optionalFloat"].float) == testObject.optionalFloat
                expect(json["unwrappedFloat"].float) == testObject.unwrappedFloat
                
                //expect(json["string"].stringValue) == testObject.string
                expect(json["optionalString"].string) == testObject.optionalString
                expect(json["unwrappedString"].string) == testObject.unwrappedString
            }
            
            it("serializes class") {
                let serializedObject = createTestClass()
                
                let testObject = serializedObject.copy()
                
                let json = objectMapper.toJSON(serializedObject)
                
                expect(json["nsnumber"].numberValue) == testObject.nsnumber
                expect(json["optionalNsnumber"].number) == testObject.optionalNsnumber
                expect(json["unwrappedNsnumber"].number) == testObject.unwrappedNsnumber
                
                expect(json["bool"].boolValue) == testObject.bool
                expect(json["optionalBool"].bool) == testObject.optionalBool
                expect(json["unwrappedBool"].bool) == testObject.unwrappedBool
                
                expect(json["int"].intValue) == testObject.int
                expect(json["optionalInt"].int) == testObject.optionalInt
                expect(json["unwrappedInt"].int) == testObject.unwrappedInt
                
                expect(json["double"].doubleValue) == testObject.double
                expect(json["optionalDouble"].double) == testObject.optionalDouble
                expect(json["unwrappedDouble"].double) == testObject.unwrappedDouble
                
                expect(json["float"].floatValue) == testObject.float
                expect(json["optionalFloat"].float) == testObject.optionalFloat
                expect(json["unwrappedFloat"].float) == testObject.unwrappedFloat
                
                //expect(json["string"].stringValue) == testObject.string
                expect(json["optionalString"].string) == testObject.optionalString
                expect(json["unwrappedString"].string) == testObject.unwrappedString
            }
            
            it("can deserialize a previously serialized struct") {
                let serializedObject = createTestStruct()
                
                let json = objectMapper.toJSON(serializedObject)
                
                let deserializedObject: StructMappable? = objectMapper.map(json)
                
                expect(deserializedObject).toNot(beNil())
                expect(deserializedObject!) == serializedObject
            }
            
            it("can deserialize a previously serialized class") {
                let serializedObject = createTestClass()
                
                let json = objectMapper.toJSON(serializedObject)
                
                let deserializedObject: ClassMappable? = objectMapper.map(json)
                expect(deserializedObject).toNot(beNil())
                expect(deserializedObject!) == serializedObject
            }
        }
    }
    
}

func randomString(length: Int = 64) -> String {
    let letters = "abcdefghijklmnopqrstuvwxyzABCDEFGHIJKLMNOPQRSTUVWYZ1234567890"
    let lettersCount = UInt32(letters.characters.count)
    
    let randomCharacters = (0..<length)
        .map { _ in arc4random_uniform(lettersCount) }
        .map(Int.init)
        .map { letters[letters.startIndex.advancedBy($0)] }
    
    return String(randomCharacters)
}

private func createTestStruct() -> StructMappable {
    var testObject = StructMappable()
    testObject.nsnumber = NSNumber(int: rand())
    testObject.optionalNsnumber = NSNumber(int: rand())
    testObject.unwrappedNsnumber = NSNumber(int: rand())
    
    testObject.bool = true
    testObject.optionalBool = true
    testObject.unwrappedBool = true
    
    testObject.int = Int(rand())
    testObject.optionalInt = Int(rand())
    testObject.unwrappedInt = Int(rand())
    
    testObject.double = Double(rand())
    testObject.optionalDouble = Double(rand())
    testObject.unwrappedDouble = Double(rand())
    
    testObject.float = Float(rand())
    testObject.optionalFloat = Float(rand())
    testObject.unwrappedFloat = Float(rand())
    
    testObject.string = randomString()
    testObject.optionalString = randomString()
    testObject.unwrappedString = randomString()
    return testObject
}

private func createTestClass() -> ClassMappable {
    let serializedObject = ClassMappable()
    serializedObject.nsnumber = NSNumber(int: rand())
    serializedObject.optionalNsnumber = NSNumber(int: rand())
    serializedObject.unwrappedNsnumber = NSNumber(int: rand())
    
    serializedObject.bool = true
    serializedObject.optionalBool = true
    serializedObject.unwrappedBool = true
    
    serializedObject.int = Int(rand())
    serializedObject.optionalInt = Int(rand())
    serializedObject.unwrappedInt = Int(rand())
    
    serializedObject.double = Double(rand())
    serializedObject.optionalDouble = Double(rand())
    serializedObject.unwrappedDouble = Double(rand())
    
    serializedObject.float = Float(rand())
    serializedObject.optionalFloat = Float(rand())
    serializedObject.unwrappedFloat = Float(rand())
    
    serializedObject.string = randomString()
    serializedObject.optionalString = randomString()
    serializedObject.unwrappedString = randomString()
    return serializedObject
}

func ==(lhs: StructMappable, rhs: StructMappable) -> Bool {
    return lhs.nsnumber == rhs.nsnumber &&
        lhs.optionalNsnumber == rhs.optionalNsnumber &&
        lhs.unwrappedNsnumber == rhs.unwrappedNsnumber &&
        
        lhs.bool == rhs.bool &&
        lhs.optionalBool == rhs.optionalBool &&
        lhs.unwrappedBool == rhs.unwrappedBool &&
        
        lhs.int == rhs.int &&
        lhs.optionalInt == rhs.optionalInt &&
        lhs.unwrappedInt == rhs.unwrappedInt &&
        
        lhs.double == rhs.double &&
        lhs.optionalDouble == rhs.optionalDouble &&
        lhs.unwrappedDouble == rhs.unwrappedDouble &&
        
        lhs.float == rhs.float &&
        lhs.optionalFloat == rhs.optionalFloat &&
        lhs.unwrappedFloat == rhs.unwrappedFloat &&
        
        lhs.string == rhs.string &&
        lhs.optionalString == rhs.optionalString &&
        lhs.unwrappedString == rhs.unwrappedString

}

func ==(lhs: ClassMappable, rhs: ClassMappable) -> Bool {
    return lhs.nsnumber == rhs.nsnumber &&
        lhs.optionalNsnumber == rhs.optionalNsnumber &&
        lhs.unwrappedNsnumber == rhs.unwrappedNsnumber &&
        
        lhs.bool == rhs.bool &&
        lhs.optionalBool == rhs.optionalBool &&
        lhs.unwrappedBool == rhs.unwrappedBool &&
        
        lhs.int == rhs.int &&
        lhs.optionalInt == rhs.optionalInt &&
        lhs.unwrappedInt == rhs.unwrappedInt &&
        
        lhs.double == rhs.double &&
        lhs.optionalDouble == rhs.optionalDouble &&
        lhs.unwrappedDouble == rhs.unwrappedDouble &&
        
        lhs.float == rhs.float &&
        lhs.optionalFloat == rhs.optionalFloat &&
        lhs.unwrappedFloat == rhs.unwrappedFloat &&
        
        lhs.string == rhs.string &&
        lhs.optionalString == rhs.optionalString &&
        lhs.unwrappedString == rhs.unwrappedString
    
}

struct StructMappable: Mappable, Equatable {
    var nsnumber: NSNumber = 0
    var optionalNsnumber: NSNumber?
    var unwrappedNsnumber: NSNumber!
    
    var bool: Bool = false
    var optionalBool: Bool?
    var unwrappedBool: Bool!
    
    var int: Int = 0
    var optionalInt: Int?
    var unwrappedInt: Int!
    
    var double: Double = 0
    var optionalDouble: Double?
    var unwrappedDouble: Double!
    
    var float: Float = 0
    var optionalFloat: Float?
    var unwrappedFloat: Float!
    
    var string: String = ""
    var optionalString: String?
    var unwrappedString: String!
    
    init?(_ map: Map) {
        mapping(map)
    }
    
    init() { }
    
    mutating func mapping(map: Map) {
        nsnumber <- map["nsnumber"]
        optionalNsnumber <- map["optionalNsnumber"]
        unwrappedNsnumber <- map["unwrappedNsnumber"]
        
        bool <- map["bool"]
        optionalBool <- map["optionalBool"]
        unwrappedBool <- map["unwrappedBool"]
        
        int <- map["int"]
        optionalInt <- map["optionalInt"]
        unwrappedInt <- map["unwrappedInt"]
        
        double <- map["double"]
        optionalDouble <- map["optionalDouble"]
        unwrappedDouble <- map["unwrappedDouble"]
        
        float <- map["float"]
        optionalFloat <- map["optionalFloat"]
        unwrappedFloat <- map["unwrappedFloat"]
        
        string <- map["string"]
        optionalString <- map["optionalString"]
        unwrappedString <- map["unwrappedString"]
    }
}

class ClassMappable: Mappable, Equatable {
    var nsnumber: NSNumber = 0
    var optionalNsnumber: NSNumber?
    var unwrappedNsnumber: NSNumber!
    
    var bool: Bool = false
    var optionalBool: Bool?
    var unwrappedBool: Bool!
    
    var int: Int = 0
    var optionalInt: Int?
    var unwrappedInt: Int!
    
    var double: Double = 0
    var optionalDouble: Double?
    var unwrappedDouble: Double!
    
    var float: Float = 0
    var optionalFloat: Float?
    var unwrappedFloat: Float!
    
    var string: String = ""
    var optionalString: String?
    var unwrappedString: String!
    
    required init?(_ map: Map) {
        mapping(map)
    }
    
    init() { }
    
    func mapping(map: Map) {
        nsnumber <- map["nsnumber"]
        optionalNsnumber <- map["optionalNsnumber"]
        unwrappedNsnumber <- map["unwrappedNsnumber"]
        
        bool <- map["bool"]
        optionalBool <- map["optionalBool"]
        unwrappedBool <- map["unwrappedBool"]
        
        int <- map["int"]
        optionalInt <- map["optionalInt"]
        unwrappedInt <- map["unwrappedInt"]
        
        double <- map["double"]
        optionalDouble <- map["optionalDouble"]
        unwrappedDouble <- map["unwrappedDouble"]
        
        float <- map["float"]
        optionalFloat <- map["optionalFloat"]
        unwrappedFloat <- map["unwrappedFloat"]
        
        string <- map["string"]
        optionalString <- map["optionalString"]
        unwrappedString <- map["unwrappedString"]
    }
    
    func copy() -> ClassMappable {
        let copy = ClassMappable()
        
        copy.nsnumber = nsnumber.copy() as! NSNumber
        copy.optionalNsnumber = optionalNsnumber?.copy() as? NSNumber
        copy.unwrappedNsnumber = unwrappedNsnumber?.copy() as? NSNumber
        
        copy.bool = bool
        copy.optionalBool = optionalBool
        copy.unwrappedBool = unwrappedBool
        
        copy.int = int
        copy.optionalInt = optionalInt
        copy.unwrappedInt = unwrappedInt
        
        copy.double = double
        copy.optionalDouble = optionalDouble
        copy.unwrappedDouble = unwrappedDouble
        
        copy.float = float
        copy.optionalFloat = optionalFloat
        copy.unwrappedFloat = unwrappedFloat
        
        copy.string = string
        copy.optionalString = optionalString
        copy.unwrappedString = unwrappedString
        
        return copy
    }
}
