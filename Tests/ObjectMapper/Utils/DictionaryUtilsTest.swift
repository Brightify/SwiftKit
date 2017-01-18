//
//  DictionaryUtilsTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class DictionaryUtilsTest: QuickSpec {
    
    override func spec() {
        describe("Dictionary extension") {
            describe("mapValue") {
                it("apply map to value") {
                    let dictionary = ["a": 1, "b": 2, "c": 3]
                    expect(dictionary.mapValue { $0 * 2 }) == ["a": 2, "b": 4, "c": 6]
                }
            }
        }
    }
    
}
