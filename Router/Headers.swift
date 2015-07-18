//
//  Headers.swift
//  Pods
//
//  Created by Tadeas Kriz on 09/07/15.
//
//

import Foundation

public protocol Header {
    var name: String { get }
    var value: String { get }
}

public extension NSMutableURLRequest {
    
    public func addHeader(header: Header) {
        addValue(header.value, forHTTPHeaderField: header.name)
    }
    
    public func setHeader(header: Header) {
        setValue(header.value, forHTTPHeaderField: header.name)
    }
    
}

public struct Headers {
    
    public enum Accept: Header {
        case ApplicationJson
        case TextPlain
        case Custom(value: String)
        
        public var name: String {
            return "Accept"
        }
        
        public var value: String {
            switch self {
            case .ApplicationJson:
                return "application/json"
            case .TextPlain:
                return "text/plain"
            case .Custom(let value):
                return value
            }
        }
    }
    
    public enum ContentType: Header {
        case ApplicationJson
        case TextPlain
        case Custom(value: String)
        
        public var name: String {
            return "Content-Type"
        }
        
        public var value: String {
            switch self {
            case .ApplicationJson:
                return "application/json"
            case .TextPlain:
                return "text/plain"
            case .Custom(let value):
                return value
            }
        }
    }
}