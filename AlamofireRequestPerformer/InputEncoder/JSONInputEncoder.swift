//
//  JSONInputEncoder.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 27/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

import SwiftyJSON

public struct JSONInputEncoder: InputEncoder {
    
    public init() {
    }
    
    public func encode(_ input: JSON, to request: inout Request) {
        request.HTTPBody = try? input.rawData()
        request.modifiers.append(Headers.ContentType.applicationJson)
    }
}
