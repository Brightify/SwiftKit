//
//  DeserializableTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class DeserializableTest: QuickSpec {
    
    override func spec() {
        describe("Deserializable") {
            describe("deserialize") {
                it("deserializes object") {
                    
                }
                context("invalid SupportedType") {
                    it("throws error") {
                        
                    }
                }
            }
        }
    }
}

private struct DeserializableStruct: Deserializable {
    
    let number: Int?
    let text: String
    
    init(_ data: DeserializableData) throws {
        number = data["number"].get()
        text = try data["text"].get()
    }
}
