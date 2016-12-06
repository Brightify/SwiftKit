//
//  URLInputEncoder.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 27/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

import SwiftyJSON

public struct URLInputEncoder: InputEncoder {
    
    public init() {
    }
    
    public func encode(_ input: JSON, to request: inout Request) {
        guard let url = request.URL,
            var components = URLComponents(url: url as URL, resolvingAgainstBaseURL: false) else { return }
        
        let percentEncodedQuery = (components.percentEncodedQuery.map { $0 + "&" } ?? "") + encodeParametersForURL(input)
        components.percentEncodedQuery = percentEncodedQuery
        request.URL = components.url
    }
}
