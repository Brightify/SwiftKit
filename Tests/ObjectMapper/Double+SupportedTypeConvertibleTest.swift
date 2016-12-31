//
//  Double+SupportedTypeConvertibleTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 31.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class Double_SupportedTypeConvertibleTest: QuickSpec {
    
    override func spec() {
        describe("Double") {
            it("can be used in ObjectMapper without transformation") {
                let objectMapper = ObjectMapper()
                let value = 1.1
                let type: SupportedType = .double(1.1)
                
                expect(objectMapper.deserialize(type)) == value
                expect(objectMapper.serialize(value)) == type
            }
        }
    }
}
