//
//  BaseScript.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 10.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

// yes y | RouterRequestGenerator/run

extension String {
    
    var isVoid: Bool {
        return self == "Void"
    }
    
    var isSupportedType: Bool {
        return self == "SupportedType"
    }
    
    var isKnownType: Bool {
        return isVoid || isSupportedType
    }
    
    var isValue: Bool {
        return self == "OUT"
    }
    
    var isArray: Bool {
        return characters.last == "]" && !characters.contains(":")
    }
    
    var isDictionary: Bool {
        return characters.last == "]" && characters.contains(":")
    }
}

let inputTypes = ["SupportedType", "Void", "IN", "IN?", "[IN]", "[IN]?", "[IN?]", "[IN?]?", "[String: IN]", "[String: IN]?", "[String: IN?]", "[String: IN?]?"]
let outputTypes = ["SupportedType", "Void", "OUT", "[OUT]", "[OUT?]", "[String: OUT]", "[String: OUT?]"]
