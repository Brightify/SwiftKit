//
//  HttpMethod.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 04.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public enum HTTPMethod: String {
    
    case connect = "CONNECT"
    case delete  = "DELETE"
    case get     = "GET"
    case head    = "HEAD"
    case options = "OPTIONS"
    case patch   = "PATCH"
    case post    = "POST"
    case put     = "PUT"
    case trace   = "TRACE"
    case unknown = "UNKNOWN"
    
    var defaultInputEncoding: InputEncoding {
        switch self {
        case .connect, .delete, .get, .head, .trace:
            return StandardInputEncoding.queryString
        default:
            return StandardInputEncoding.httpBody
        }
    }
}
