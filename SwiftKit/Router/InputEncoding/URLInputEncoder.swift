//
//  URLInputEncoder.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 27/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

import SwiftyJSON
import Alamofire

private func query(_ parameters: JSON) -> String {
    return parameters
        .sorted { $0.0 < $1.0 }
        .map { ($0, $1.rawValue) }
        .map(URLEncoding.queryString.queryComponents)
        .reduce([]) { $0 + $1 }
        .map { "\($0)=\($1)" }
        .joined(separator: "&")
}

public struct URLInputEncoder: InputEncoder {
    public init() { }
    
    public func encode(_ input: JSON, to request: inout Request) {
        guard let url = request.URL,
            var components = URLComponents(url: url as URL, resolvingAgainstBaseURL: false) else { return }
        
        let percentEncodedQuery = (components.percentEncodedQuery.map { $0 + "&" } ?? "") + query(input)
        components.percentEncodedQuery = percentEncodedQuery
        request.URL = components.url
    }
}

public struct FormInputEncoder: InputEncoder {
    public init() { }
    
    public func encode(_ input: JSON, to request: inout Request) {
        let oldContentType = request.modifiers.filter { $0 is Headers.ContentType }.first
        if oldContentType == nil {
            request.modifiers.append(Headers.ContentType.applicationFormUrlencoded)
        }

        request.HTTPBody = query(input).data(using: String.Encoding.utf8, allowLossyConversion: false)
    }
}
