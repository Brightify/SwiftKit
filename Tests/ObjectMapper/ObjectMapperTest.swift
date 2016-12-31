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

// TODO
class ObjectMapperTest: QuickSpec {
    
    override func spec() {
        describe("ObjectMapper") {
            var objectMapper: ObjectMapper!
            beforeEach {
                objectMapper = ObjectMapper()
            }
            describe("serialize") {
                context("value is Serializable") {
                    var stub: SerializableStub?
                    var valueResult: SupportedType!
                    beforeEach {
                        stub = SerializableStub(number: 1)
                        valueResult = .int(1)
                    }
                    it("works with value") {
                        let data: SerializableStub? = stub
                        let result: SupportedType = valueResult
                        expect(objectMapper.serialize(data)) == result
                    }
                    it("works with array") {
                        let data: [SerializableStub]? = [stub!, stub!]
                        let result: SupportedType = .array([valueResult, valueResult])
                        expect(objectMapper.serialize(data)) == result
                    }
                    it("works with dictionary") {
                        let data: [String: SerializableStub]? = ["a": stub!, "b": stub!]
                        let result: SupportedType = .dictionary(["a": valueResult, "b": valueResult])
                        expect(objectMapper.serialize(data)) == result
                    }
                    it("works with array with optionals") {
                        let data: [SerializableStub?]? = [stub, stub]
                        let result: SupportedType = .array([valueResult, valueResult])
                        expect(objectMapper.serialize(data)) == result
                    }
                    it("works with dictionary with optionals") {
                        let data: [String: SerializableStub?]? = ["a": stub, "b": stub]
                        let result: SupportedType = .dictionary(["a": valueResult, "b": valueResult])
                        expect(objectMapper.serialize(data)) == result
                    }
                }
                context("transformation provided") {
                    let transformation = StubSerializableTransformation()
                    var stub: Stub?
                    var valueResult: SupportedType!
                    beforeEach {
                        stub = Stub(number: 1)
                        valueResult = .int(1)
                    }
                    it("works with value") {
                        let data: Stub? = stub
                        let result: SupportedType = valueResult
                        expect(objectMapper.serialize(data, using: transformation)) == result
                    }
                    it("works with array") {
                        let data: [Stub]? = [stub!, stub!]
                        let result: SupportedType = .array([valueResult, valueResult])
                        expect(objectMapper.serialize(data, using: transformation)) == result
                    }
                    it("works with dictionary") {
                        let data: [String: Stub]? = ["a": stub!, "b": stub!]
                        let result: SupportedType = .dictionary(["a": valueResult, "b": valueResult])
                        expect(objectMapper.serialize(data, using: transformation)) == result
                    }
                    it("works with array with optionals") {
                        let data: [Stub?]? = [stub, stub]
                        let result: SupportedType = .array([valueResult, valueResult])
                        expect(objectMapper.serialize(data, using: transformation)) == result
                    }
                    it("works with dictionary with optionals") {
                        let data: [String: Stub?]? = ["a": stub, "b": stub]
                        let result: SupportedType = .dictionary(["a": valueResult, "b": valueResult])
                        expect(objectMapper.serialize(data, using: transformation)) == result
                    }
                }
            }
            describe("deserialize") {
                /*context("value is Deserializable") {
                    var supportedType: SupportedType!
                    var stub: DeserializableStub?
                    beforeEach {
                        supportedType = .int(1)
                        stub = DeserializableStub(number: 1)
                    }
                    it("works with value") {
                        let data: SupportedType = supportedType
                        let result: DeserializableStub = stub
                        expect(objectMapper.serialize(data)) == result
                    }
                    it("works with array") {
                        let data: [SerializableStub]? = [stub!, stub!]
                        let result: SupportedType = .array([valueResult, valueResult])
                        expect(objectMapper.serialize(data)) == result
                    }
                    it("works with dictionary") {
                        let data: [String: SerializableStub]? = ["a": stub!, "b": stub!]
                        let result: SupportedType = .dictionary(["a": valueResult, "b": valueResult])
                        expect(objectMapper.serialize(data)) == result
                    }
                    it("works with array with optionals") {
                        let data: [SerializableStub?]? = [stub, stub]
                        let result: SupportedType = .array([valueResult, valueResult])
                        expect(objectMapper.serialize(data)) == result
                    }
                    it("works with dictionary with optionals") {
                        let data: [String: SerializableStub?]? = ["a": stub, "b": stub]
                        let result: SupportedType = .dictionary(["a": valueResult, "b": valueResult])
                        expect(objectMapper.serialize(data)) == result
                    }
                }
                context("transformation provided") {
                    let transformation = StubSerializableTransformation()
                    var stub: Stub?
                    var valueResult: SupportedType!
                    beforeEach {
                        stub = Stub(number: 1)
                        valueResult = .int(1)
                    }
                    it("works with value") {
                        let data: Stub? = stub
                        let result: SupportedType = valueResult
                        expect(objectMapper.serialize(data, using: transformation)) == result
                    }
                    it("works with array") {
                        let data: [Stub]? = [stub!, stub!]
                        let result: SupportedType = .array([valueResult, valueResult])
                        expect(objectMapper.serialize(data, using: transformation)) == result
                    }
                    it("works with dictionary") {
                        let data: [String: Stub]? = ["a": stub!, "b": stub!]
                        let result: SupportedType = .dictionary(["a": valueResult, "b": valueResult])
                        expect(objectMapper.serialize(data, using: transformation)) == result
                    }
                    it("works with array with optionals") {
                        let data: [Stub?]? = [stub, stub]
                        let result: SupportedType = .array([valueResult, valueResult])
                        expect(objectMapper.serialize(data, using: transformation)) == result
                    }
                    it("works with dictionary with optionals") {
                        let data: [String: Stub?]? = ["a": stub, "b": stub]
                        let result: SupportedType = .dictionary(["a": valueResult, "b": valueResult])
                        expect(objectMapper.serialize(data, using: transformation)) == result
                    }
                }*/
            }
            describe("serializableData") {
                it("returns SerializableData") {
                    
                }
            }
            describe("deserializableData") {
                it("returns DeserializableData") {
                    
                }
            }
            context("used polymorp") {
                // TODO
            }
        }
    }
}

private struct SerializableStub: Serializable {
    
    let number: Int
    
    func serialize(to data: inout SerializableData) {
        data.set(number)
    }
}

private struct DeserializableStub: Deserializable {
    
    let number: Int
    
    init(_ data: DeserializableData) throws {
        number = try data.get()
    }
    
    init(number: Int) {
        self.number = number
    }
}

extension DeserializableStub: Equatable {
}

fileprivate func ==(lhs: DeserializableStub, rhs: DeserializableStub) -> Bool {
    return lhs.number == rhs.number
}

private struct Stub {
    
    let number: Int
}

extension Stub: Equatable {
}

fileprivate func ==(lhs: Stub, rhs: Stub) -> Bool {
    return lhs.number == rhs.number
}

private struct StubSerializableTransformation: SerializableTransformation {
    
    func transform(object: Stub?) -> SupportedType {
        return object.map { .int($0.number) } ?? .null
    }
}

private struct StubDeserializableTransformation: DeserializableTransformation {
    
    func transform(from value: SupportedType) -> Stub? {
        if let number = value.int {
            return Stub(number: number)
        } else {
            return nil
        }
    }
}
