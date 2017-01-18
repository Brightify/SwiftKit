//
//  URLTransformationTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 31.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class URLTransformationTest: QuickSpec {
    
    override func spec() {
        describe("URLTransformation") {
            let transformation = URLTransformation()
            let value = URL(string: "https://google.com/a")
            let type: SupportedType = .string("https://google.com/a")
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
                context("useRelative is false") {
                    it("transforms value to SupportedType using absolute path") {
                        expect(transformation.transform(object: value)) == type
                    }
                }
                context("useRelative is true") {
                    it("transforms value to SupportedType using relative path") {
                        let transformation = URLTransformation(useRelative: true)
                        
                        expect(transformation.transform(object: value)) == SupportedType.string("/a")
                    }
                }
                it("transforms nil to SupportedType.null") {
                    expect(transformation.transform(object: nil)) == SupportedType.null
                }
            }
        }
    }
}
