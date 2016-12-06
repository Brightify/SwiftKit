//
//  FormInputEncoder.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 04.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SwiftyJSON

public struct FormInputEncoder: InputEncoder {
    
    public init() {
    }
    
    public func encode(_ input: SupportedType, to request: inout Request) {
        let oldContentType = request.modifiers.filter { $0 is Headers.ContentType }.first
        if oldContentType == nil {
            request.modifiers.append(Headers.ContentType.applicationFormUrlencoded)
        }
        
        request.HTTPBody = encodeParametersForURL(input).data(using: String.Encoding.utf8, allowLossyConversion: false)
    }
}
