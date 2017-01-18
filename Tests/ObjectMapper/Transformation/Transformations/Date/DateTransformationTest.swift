//
//  DateTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 31.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class DateTransformationTest: QuickSpec {
    
    override func spec() {
        describe("DateTransformation") {
            let transformation = DateTransformation()
            let value = Date(timeIntervalSince1970: 1000)
            let type: SupportedType = .double(1000)
            let incorrectType: SupportedType = .int(1)
            
            describe("transform(from)") {
                it("transforms correct SupportedType to value") {
                    expect(transformation.transform(from: type)) == value
                }
                it("transforms incorrect SupportedType to nil") {
                    expect(transformation.transform(from: incorrectType)).to(beNil())
                }
            }
            describe("transform(object)") {
                it("transforms value to SupportedType") {
                    expect(transformation.transform(object: value)) == type
                }
                it("transforms nil to SupportedType.null") {
                    expect(transformation.transform(object: nil)) == SupportedType.null
                }
            }
        }
    }
}
