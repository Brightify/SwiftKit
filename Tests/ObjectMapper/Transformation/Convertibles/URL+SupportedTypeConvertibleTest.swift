//
//  URL+SupportedTypeConvertibleTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 31.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class URL_SupportedTypeConvertibleTest: QuickSpec {
    
    override func spec() {
        describe("URL") {
            it("can be used in ObjectMapper without transformation") {
                let objectMapper = ObjectMapper()
                let value = URL(string: "a")
                let type: SupportedType = .string("a")
                
                expect(objectMapper.deserialize(type)) == value
                expect(objectMapper.serialize(value)) == type
            }
        }
    }
}
