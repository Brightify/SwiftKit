//
//  SupportedTypeTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class SupportedTypeTest: QuickSpec {
    
    override func spec() {
        describe("SupportedType") {
            describe("isNull") {
                it("returns true if is null") {
                    let type: SupportedType = .null
                    expect(type.isNull) == true
                }
                it("returns false if is not null") {
                    let type: SupportedType = .bool(true)
                    expect(type.isNull) == false
                }
            }
            describe("string") {
                it("returns string if is string") {
                    let type: SupportedType = .string("a")
                    expect(type.string) == "a"
                }
                it("returns nil if is not string") {
                    let type: SupportedType = .bool(true)
                    expect(type.string).to(beNil())
                }
            }
            describe("number") {
                it("returns number if is number") {
                    let type: SupportedType = .number(SupportedNumber(int: 1))
                    expect(type.number) == SupportedNumber(int: 1)
                }
                it("returns nil if is not number") {
                    let type: SupportedType = .bool(true)
                    expect(type.number).to(beNil())
                }
            }
            describe("bool") {
                it("returns bool if is bool") {
                    let type: SupportedType = .bool(true)
                    expect(type.bool) == true
                }
                it("returns nil if is not bool") {
                    let type: SupportedType = .int(1)
                    expect(type.bool).to(beNil())
                }
            }
            describe("array") {
                it("returns array if is array") {
                    let type: SupportedType = .array([.bool(true), .bool(false)])
                    expect(type.array) == [.bool(true), .bool(false)]
                }
                it("returns nil if is not array") {
                    let type: SupportedType = .bool(true)
                    expect(type.array).to(beNil())
                }
            }
            describe("dictionary") {
                it("returns dictionary if is dictionary") {
                    let type: SupportedType = .dictionary(["a": .bool(true), "b": .bool(false)])
                    expect(type.dictionary) == ["a": .bool(true), "b": .bool(false)]
                }
                it("returns nil if is not dictionary") {
                    let type: SupportedType = .bool(true)
                    expect(type.dictionary).to(beNil())
                }
            }
            describe("int") {
                it("returns int if is int") {
                    expect(SupportedType.int(1).int) == 1
                    expect(SupportedType.number(SupportedNumber(int: 1)).int) == 1
                    expect(SupportedType.number(SupportedNumber(int: 1, double: 2)).int) == 1
                }
                it("returns nil if is not int") {
                    expect(SupportedType.bool(true).int).to(beNil())
                    expect(SupportedType.double(1).int).to(beNil())
                    expect(SupportedType.number(SupportedNumber(double: 1)).int).to(beNil())
                }
            }
            describe("double") {
                it("returns double if is double") {
                    expect(SupportedType.double(1).double) == 1
                    expect(SupportedType.number(SupportedNumber(double: 1)).double) == 1
                    expect(SupportedType.number(SupportedNumber(int: 2, double: 1)).double) == 1
                }
                it("returns nil if is not double") {
                    expect(SupportedType.bool(true).double).to(beNil())
                    expect(SupportedType.int(1).double).to(beNil())
                    expect(SupportedType.number(SupportedNumber(int: 1)).double).to(beNil())
                }
            }
            describe("addToDictionary") {
                it("adds value to dictionary") {
                    var type: SupportedType = .dictionary(["a": .bool(true)])
                    
                    type.addToDictionary(key: "b", value: .bool(false))
                    
                    expect(type) == SupportedType.dictionary(["a": .bool(true), "b": .bool(false)])
                }
                it("creates new dictionary if necessary") {
                    var type: SupportedType = .bool(true)
                    
                    type.addToDictionary(key: "b", value: .bool(false))
                    
                    expect(type) == SupportedType.dictionary(["b": .bool(false)])
                }
            }
            describe("==") {
                it("returns true if equal") {
                    expect(SupportedType.null) == SupportedType.null
                    expect(SupportedType.string("a")) == SupportedType.string("a")
                    expect(SupportedType.number(SupportedNumber(int: 1))) == SupportedType.number(SupportedNumber(int: 1))
                    expect(SupportedType.bool(true)) == SupportedType.bool(true)
                    expect(SupportedType.array([.bool(true)])) == SupportedType.array([.bool(true)])
                    expect(SupportedType.dictionary(["a": .bool(true)])) == SupportedType.dictionary(["a": .bool(true)])
                }
                it("returns false if not equal") {
                    expect(SupportedType.string("a")) != SupportedType.string("b")
                    expect(SupportedType.number(SupportedNumber(int: 1))) != SupportedType.number(SupportedNumber(int: 2))
                    expect(SupportedType.bool(true)) != SupportedType.bool(false)
                    expect(SupportedType.array([.bool(true)])) != SupportedType.array([.bool(false)])
                    expect(SupportedType.dictionary(["a": .bool(true)])) != SupportedType.dictionary(["a": .bool(false)])
                    
                    expect(SupportedType.null) != SupportedType.bool(true)
                    expect(SupportedType.string("a")) != SupportedType.bool(true)
                    expect(SupportedType.number(SupportedNumber(int: 1))) != SupportedType.bool(true)
                    expect(SupportedType.array([.bool(true)])) != SupportedType.bool(true)
                    expect(SupportedType.dictionary(["a": .bool(true)])) != SupportedType.bool(true)
                }
            }
        }
    }
}
