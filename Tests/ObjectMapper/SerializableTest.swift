//
//  SerializableTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 27.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class SerializableTest: QuickSpec {
    
    override func spec() {
        describe("Serializable") {
            describe("serialize") {
                it("serializes object") {
                    
                }
            }
        }
    }
}

private struct SerializableStruct: Serializable {
    
    var number: Int?
    var text: String = ""
    
    init(number: Int?, text: String) {
        self.number = number
        self.text = text
    }
    
    func serialize(to data: inout SerializableData) {
        data["number"].set(number)
        data["text"].set(text)
    }
}

