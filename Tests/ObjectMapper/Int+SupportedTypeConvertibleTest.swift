//
//  Int+SupportedTypeConvertibleTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 31.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class Int_SupportedTypeConvertibleTest: QuickSpec {
    
    override func spec() {
        describe("Int") {
            it("can be used in ObjectMapper without transformation") {
                let objectMapper = ObjectMapper()
                let value = 1
                let type: SupportedType = .int(1)
                
                expect(objectMapper.deserialize(type)) == value
                expect(objectMapper.serialize(value)) == type
            }
        }
    }
}
