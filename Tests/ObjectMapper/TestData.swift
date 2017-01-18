//
//  TestData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 01.01.17.
//  Copyright © 2017 Brightify. All rights reserved.
//

import SwiftKit
import Nimble

struct TestData {
    
    static let deserializableStruct = DeserializableStruct(number: 1, text: "a", points: [2], children: [])
    static let mappableStruct = MappableStruct(number: 1, text: "a", points: [2], children: [])
    static let mappableClass = MappableClass(number: 1, text: "a", points: [2], children: [])
    static let serializableStruct = SerializableStruct(number: 1, text: "a", points: [2], children: [])
    
    static let type = SupportedType.dictionary(["number": .int(1), "text": .string("a"), "points": .array([.double(2)]), "children": .array([])])
    static let invalidType = SupportedType.dictionary(["number": .int(1)])
    
    // Returned elements == Floor[ x! * e ]
    static func generate(x: Int) -> MappableStruct {
        var object: MappableStruct = MappableStruct(number: 0, text: "0", points: [], children: [])
        
        for i in 1...x {
            object = MappableStruct(number: i, text: "\(i)", points: (1...i).map { Double($0) }, children: (1...i).map { _ in object })
        }
        return object
    }
    
    struct DeserializableStruct: Deserializable {
        
        let number: Int?
        let text: String
        let points: [Double]
        let children: [MappableStruct]
        
        init(number: Int?, text: String, points: [Double], children: [MappableStruct]) {
            self.number = number
            self.text = text
            self.points = points
            self.children = children
        }
        
        init(_ data: DeserializableData) throws {
            number = data["number"].get()
            text = try data["text"].get()
            points = data["points"].get(or: [])
            children = data["children"].get(or: [])
        }
    }
    
    struct MappableStruct: Mappable {
        
        private(set) var number: Int?
        private(set) var text: String = ""
        private(set) var points: [Double] = []
        private(set) var children: [MappableStruct] = []
        
        init(number: Int?, text: String, points: [Double], children: [MappableStruct]) {
            self.number = number
            self.text = text
            self.points = points
            self.children = children
        }
        
        init(_ data: DeserializableData) throws {
            try mapping(data)
        }
        
        mutating func mapping(_ data: inout MappableData) throws {
            data["number"].map(&number)
            try data["text"].map(&text)
            data["points"].map(&points, or: [])
            data["children"].map(&children, or: [])
        }
    }
    
    class MappableClass: Mappable {
        
        let number: Int?
        private(set) var text: String = ""
        private(set) var points: [Double] = []
        private(set) var children: [MappableStruct] = []
        
        init(number: Int?, text: String, points: [Double], children: [MappableStruct]) {
            self.number = number
            self.text = text
            self.points = points
            self.children = children
        }
        
        required init(_ data: DeserializableData) throws {
            number = data["number"].get()
            
            try mapping(data)
        }
        
        func serialize(to data: inout SerializableData) {
            mapping(&data)
            
            data["number"].set(number)
        }
        
        func mapping(_ data: inout MappableData) throws {
            try data["text"].map(&text)
            data["points"].map(&points, or: [])
            data["children"].map(&children, or: [])
        }
    }
    
    struct SerializableStruct: Serializable {
        
        let number: Int?
        let text: String
        let points: [Double]
        let children: [MappableStruct]
        
        init(number: Int?, text: String, points: [Double], children: [MappableStruct]) {
            self.number = number
            self.text = text
            self.points = points
            self.children = children
        }
        
        func serialize(to data: inout SerializableData) {
            data["number"].set(number)
            data["text"].set(text)
            data["points"].set(points)
            data["children"].set(children)
        }
    }
    
    struct Map {
        
        static let validType = SupportedType.dictionary([
            "value": .int(1),
            "array": .array([.int(1), .int(2)]),
            "dictionary": .dictionary(["a": .int(1), "b": .int(2)]),
            "optionalArray": .array([.int(1), .null]),
            "optionalDictionary": .dictionary(["a": .int(1), "b": .null]),
            ])
        
        static let invalidType = SupportedType.dictionary([
            "value": .double(1),
            "array": .array([.double(1), .int(2)]),
            "dictionary": .dictionary(["a": .double(1), "b": .int(2)]),
            "optionalArray": .double(1),
            "optionalDictionary": .null
            ])
        
        static let nullType = SupportedType.dictionary([
            "value": .null,
            "array": .null,
            "dictionary": .null,
            "optionalArray": .null,
            "optionalDictionary": .null,
            ])
        
        static let pathType = SupportedType.dictionary(["a": .dictionary(["b": .int(1)])])
        
        static func assertValidType(_ value: Int?, _ array: [Int]?, _ dictionary: [String: Int]?, _ optionalArray: [Int?]?,
                                    _ optionalDictionary: [String: Int?]?, file: FileString = #file, line: UInt = #line) {
            expect(value, file: file, line: line) == 1
            expect(array, file: file, line: line) == [1, 2]
            expect(dictionary, file: file, line: line) == ["a": 1, "b": 2]
            expect(areEqual(optionalArray, [1, nil]), file: file, line: line).to(beTrue())
            expect(areEqual(optionalDictionary, ["a": 1, "b": nil]), file: file, line: line).to(beTrue())
        }
        
        static func assertValidTypeUsingTransformation(_ value: Int?, _ array: [Int]?, _ dictionary: [String: Int]?, _ optionalArray: [Int?]?,
                                    _ optionalDictionary: [String: Int?]?, file: FileString = #file, line: UInt = #line) {
            expect(value, file: file, line: line) == 2
            expect(array, file: file, line: line) == [2, 4]
            expect(dictionary, file: file, line: line) == ["a": 2, "b": 4]
            expect(areEqual(optionalArray, [2, nil]), file: file, line: line).to(beTrue())
            expect(areEqual(optionalDictionary, ["a": 2, "b": nil]), file: file, line: line).to(beTrue())
        }
        
        static func assertInvalidTypeOr(_ value: Int?, _ array: [Int]?, _ dictionary: [String: Int]?, _ optionalArray: [Int?]?,
                                                       _ optionalDictionary: [String: Int?]?, file: FileString = #file, line: UInt = #line) {
            expect(value, file: file, line: line) == 0
            expect(array, file: file, line: line) == [0]
            expect(dictionary, file: file, line: line) == ["a": 0]
            expect(areEqual(optionalArray, [0]), file: file, line: line).to(beTrue())
            expect(areEqual(optionalDictionary, ["a": 0]), file: file, line: line).to(beTrue())
        }
        
        static func assertInvalidType(_ value: Int?, _ array: [Int]?, _ dictionary: [String: Int]?, _ optionalArray: [Int?]?,
                                    _ optionalDictionary: [String: Int?]?, file: FileString = #file, line: UInt = #line) {
            expect(value, file: file, line: line).to(beNil())
            expect(array, file: file, line: line).to(beNil())
            expect(dictionary, file: file, line: line).to(beNil())
            expect(optionalArray, file: file, line: line).to(beNil())
            expect(optionalDictionary, file: file, line: line).to(beNil())
        }
    }
    
    struct StaticPolymorph {
        
        class A: Polymorphic {
            
            class var polymorphicKey: String {
                return "K"
            }
            
            class var polymorphicInfo: PolymorphicInfo {
                return createPolymorphicInfo().with(subtype: B.self)
            }
        }
        
        class B: A {
            
            override class var polymorphicInfo: PolymorphicInfo {
                // D is intentionally registered here.
                return createPolymorphicInfo().with(subtypes: C.self, D.self)
            }
        }
        
        class C: B {
            
            override class var polymorphicKey: String {
                return "C"
            }
        }
        
        class D: C {
            
            override class var polymorphicInfo: PolymorphicInfo {
                return createPolymorphicInfo(name: "D2")
            }
        }
        
        // Intentionally not registered.
        class E: D {
        }
        
        class X {
        }
    }
    
    struct PolymorphicTypes {
        
        static let a = A(id: 1)
        static let b = B(id: 2, name: "name")
        static let c = C(id: 3, number: 0)
        
        static let aType = SupportedType.dictionary(["id": .int(1), "type": .string("A")])
        static let bType = SupportedType.dictionary(["id": .int(2), "name": .string("name"), "type": .string("B")])
        static let cType = SupportedType.dictionary(["id": .int(3), "number": .int(0), "type": .string("C")])
        
        static let aTypeWithoutPolymorphicData = SupportedType.dictionary(["id": .int(1)])
        static let bTypeWithoutPolymorphicData = SupportedType.dictionary(["id": .int(2), "name": .string("name")])
        static let cTypeWithoutPolymorphicData = SupportedType.dictionary(["id": .int(3), "number": .int(0)])
        
        class A: PolymorphicMappable {
            
            static var polymorphicKey = "type"
            
            static var polymorphicInfo: PolymorphicInfo {
                return createPolymorphicInfo().with(subtypes: B.self, C.self)
            }
            
            let id: Int
            
            init(id: Int) {
                self.id = id
            }
            
            required init(_ data: DeserializableData) throws {
                id = try data["id"].get()
                
                try mapping(data)
            }
            
            func serialize(to data: inout SerializableData) {
                data["id"].set(id)
                
                mapping(&data)
            }
            
            func mapping(_ data: inout MappableData) throws {
            }
        }
        
        class B: A {
            
            var name: String?
            
            init(id: Int, name: String?) {
                super.init(id: id)
                
                self.name = name
            }
            
            required init(_ data: DeserializableData) throws {
                try super.init(data)
            }
            
            override func mapping(_ data: inout MappableData) throws {
                try super.mapping(&data)
                
                data["name"].map(&name)
            }
        }
        
        class C: A {
            
            var number: Int?
            
            init(id: Int, number: Int?) {
                super.init(id: id)
                
                self.number = number
            }
            
            required init(_ data: DeserializableData) throws {
                try super.init(data)
            }
            
            override func mapping(_ data: inout MappableData) throws {
                try super.mapping(&data)
                
                data["number"].map(&number)
            }
        }
    }
    
    struct CustomIntTransformation: Transformation {
        
        typealias Object = Int
        
        func transform(from value: SupportedType) -> Int? {
            return value.int.map { $0 * 2 } ?? nil
        }
        
        func transform(object: Int?) -> SupportedType {
            return object.map { .int($0 / 2) } ?? .null
        }
    }
}

extension TestData.DeserializableStruct: Equatable {
}

func ==(lhs: TestData.DeserializableStruct, rhs: TestData.DeserializableStruct) -> Bool {
    return lhs.number == rhs.number && lhs.text == rhs.text && lhs.points == rhs.points && lhs.children == rhs.children
}

extension TestData.MappableStruct: Equatable {
}

func ==(lhs: TestData.MappableStruct, rhs: TestData.MappableStruct) -> Bool {
    return lhs.number == rhs.number && lhs.text == rhs.text && lhs.points == rhs.points && lhs.children == rhs.children
}

extension TestData.MappableClass: Equatable {
}

func ==(lhs: TestData.MappableClass, rhs: TestData.MappableClass) -> Bool {
    return lhs.number == rhs.number && lhs.text == rhs.text && lhs.points == rhs.points && lhs.children == rhs.children
}

extension TestData.SerializableStruct: Equatable {
}

func ==(lhs: TestData.SerializableStruct, rhs: TestData.SerializableStruct) -> Bool {
    return lhs.number == rhs.number && lhs.text == rhs.text && lhs.points == rhs.points && lhs.children == rhs.children
}

func areEqual(_ lhs: [Int?]?, _ rhs: [Int?]?) -> Bool {
    if let lhs = lhs, let rhs = rhs {
        if lhs.count == rhs.count {
            for i in lhs.indices {
                if lhs[i] != rhs[i] {
                    return false
                }
            }
            return true
        }
    }
    return lhs == nil && rhs == nil
}

func areEqual(_ lhs: [String: Int?]?, _ rhs: [String: Int?]?) -> Bool {
    if let lhs = lhs, let rhs = rhs {
        if lhs.count == rhs.count {
            for i in lhs.keys {
                if let lValue = lhs[i], let rValue = rhs[i], lValue == rValue {
                    continue
                } else {
                    return false
                }
            }
            return true
        }
    }
    return lhs == nil && rhs == nil
}
