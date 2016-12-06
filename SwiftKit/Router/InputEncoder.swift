//
//  InputEncoder.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 05.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol InputEncoder {
    
    func encodeToQueryString(input: SupportedType, to request: inout Request)
    
    func encodeToHttpBody(input: SupportedType, to request: inout Request)
    
    func encodeCustom(input: SupportedType, to request: inout Request, inputEncoding: InputEncoding)
}

extension InputEncoder {
    
    public func encodeCustom(input: SupportedType, to request: inout Request, inputEncoding: InputEncoding) {
        preconditionFailure("Unknown input encoding \(inputEncoding).")
    }
}
