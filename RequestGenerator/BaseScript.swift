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
}

let inputTypes = ["SupportedType", "Void", "IN", "IN?", "[IN]", "[IN]?", "[IN?]", "[IN?]?", "[String: IN]", "[String: IN]?", "[String: IN?]", "[String: IN?]?"]
let outputTypes = ["SupportedType", "Void", "OUT", "[OUT]", "[OUT?]", "[String: OUT]", "[String: OUT?]"]
