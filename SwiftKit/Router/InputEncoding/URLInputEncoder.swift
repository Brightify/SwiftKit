//
//  URLInputEncoder.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 27/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

import SwiftyJSON
import Alamofire

private func query(parameters: JSON) -> String {
    return parameters
        .sort { $0.0 < $1.0 }
        .map { ($0, $1.rawValue) }
        .map(ParameterEncoding.URL.queryComponents)
        .reduce([]) { $0 + $1 }
        .map { "\($0)=\($1)" }
        .joinWithSeparator("&")
}

public struct URLInputEncoder: InputEncoder {
    public init() { }
    
    public func encode(input: JSON, inout to request: Request) {
        guard let url = request.URL, components = NSURLComponents(URL: url, resolvingAgainstBaseURL: false) else { return }
        
        let percentEncodedQuery = (components.percentEncodedQuery.map { $0 + "&" } ?? "") + query(input)
        components.percentEncodedQuery = percentEncodedQuery
        request.URL = components.URL
    }
}

public struct FormInputEncoder: InputEncoder {
    public init() { }
    
    public func encode(input: JSON, inout to request: Request) {
        let oldContentType = request.modifiers.filter { $0 is Headers.ContentType }.first
        if oldContentType == nil {
            request.modifiers.append(Headers.ContentType.ApplicationFormUrlencoded)
        }

        request.HTTPBody = query(input).dataUsingEncoding(NSUTF8StringEncoding, allowLossyConversion: false)
    }
}