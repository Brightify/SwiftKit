//
//  ISO8601DateTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 31.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class ISO8601DateTransformationTest: QuickSpec {
    
    override func spec() {
        describe("ISO8601DateTransformation") {
            let formatter = DateFormatter()
            formatter.locale = Locale(identifier: "en_US_POSIX")
            formatter.dateFormat = "yyyy-MM-dd'T'HH:mm:ssZZZZZ"
            
            let transformation = ISO8601DateTransformation()
            let value = formatter.date(from: "2016-12-31T11:00:32+01:00")
            let type: SupportedType = .string("2016-12-31T11:00:32+01:00")
            let incorrectType: SupportedType = .double(1)
            
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
