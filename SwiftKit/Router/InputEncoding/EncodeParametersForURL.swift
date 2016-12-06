//
//  EncodeParametersForURL.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 04.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import SwiftyJSON
import Alamofire

internal func encodeParametersForURL(_ parameters: JSON) -> String {
    return parameters
        .sorted { $0.0 < $1.0 }
        .map { ($0, $1.rawValue) }
        .map(URLEncoding.queryString.queryComponents)
        .reduce([]) { $0 + $1 }
        .map { "\($0)=\($1)" }
        .joined(separator: "&")
}
