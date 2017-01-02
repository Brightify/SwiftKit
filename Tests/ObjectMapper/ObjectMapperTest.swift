//
//  ObjectMapperTest.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 24.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class ObjectMapperTest: QuickSpec {
    
    override func spec() {
        describe("ObjectMapper") {
            context("with polymorph") {
                let objectMapper = ObjectMapper(polymorph: StaticPolymorph())
                
                describe("serialize") {
                    context("not polymorphic type") {
                        it("serializes data") {
                            
                        }
                    }
                    context("polymorphic type") {
                        it("serializes data and writes type info") {
                            
                        }
                    }
                }
                describe("deserialize") {
                    context("not polymorphic type") {
                        it("deserializes data") {
                            
                        }
                    }
                    context("polymorphic type") {
                        it("deserializes data with correct type") {
                            
                        }
                    }
                }
            }
            context("without polymorph") {
                let objectMapper = ObjectMapper()
                
                describe("serialize") {
                    it("serializes polymorhic type like not polymorphic") {
                        
                    }
                }
                describe("deserialize") {
                    it("deserializes polymorhic type like not polymorphic") {
                        
                    }
                }
            }
        }
    }
}
