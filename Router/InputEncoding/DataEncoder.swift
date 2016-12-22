//
//  DataEncoder.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 05.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

public protocol DataEncoder {
    
    func encodeToQueryString(input: SupportedType, to request: inout Request)
    
    func encodeToHttpBody(input: SupportedType, to request: inout Request)
    
    func encodeCustom(input: SupportedType, to request: inout Request, inputEncoding: InputEncoding)
    
    func decode(response: Response<Data>) -> Response<SupportedType>
}

extension DataEncoder {
    
    public func encodeCustom(input: SupportedType, to request: inout Request, inputEncoding: InputEncoding) {
        preconditionFailure("Unknown input encoding \(inputEncoding).")
    }
}
