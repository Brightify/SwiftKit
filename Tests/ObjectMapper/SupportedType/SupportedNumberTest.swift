//
//  SupportedNumberTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 30.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class SupportedNumberTest: QuickSpec {
    
    override func spec() {
        describe("SupportedNumber") {
            describe("int") {
                it("returns int if init(Int) is used") {
                    let number = SupportedNumber(int: 1)
                    expect(number.int) == 1
                }
                it("returns int if init(Int,Double) is used") {
                    let number = SupportedNumber(int: 1, double: 2)
                    expect(number.int) == 1
                }
                it("returns nil otherwise") {
                    let number = SupportedNumber(double: 2)
                    expect(number.int).to(beNil())
                }
            }
            describe("double") {
                it("returns double if init(Double) is used") {
                    let number = SupportedNumber(double: 2)
                    expect(number.double) == 2
                }
                it("returns double if init(Int,Double) is used") {
                    let number = SupportedNumber(int: 1, double: 2)
                    expect(number.double) == 2
                }
                it("returns nil otherwise") {
                    let number = SupportedNumber(int: 1)
                    expect(number.double).to(beNil())
                }
            }
            describe("==") {
                it("returns true if int and double are equal") {
                    expect(SupportedNumber(int: 1)) == SupportedNumber(int: 1)
                    expect(SupportedNumber(double: 2)) == SupportedNumber(double: 2)
                    expect(SupportedNumber(int: 1, double: 2)) == SupportedNumber(int: 1, double: 2)
                }
                it("returns false if int and double are not equal") {
                    expect(SupportedNumber(int: 1)) != SupportedNumber(int: 2)
                    expect(SupportedNumber(int: 1)) != SupportedNumber(double: 2)
                    expect(SupportedNumber(int: 1)) != SupportedNumber(int: 1, double: 2)
                    expect(SupportedNumber(int: 1, double: 2)) != SupportedNumber(int: 2, double: 2)
                }
            }
        }
    }
}
