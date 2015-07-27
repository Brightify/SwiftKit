//
//  Headers.swift
//  Pods
//
//  Created by Tadeas Kriz on 09/07/15.
//
//

import Foundation

public protocol Header: RequestModifier {
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
    
    public struct Custom: Header {
        public var name: String
        public var value: String
        
        public init(_ name: String, _ value: String) {
            self.name = name
            self.value = value
        }
    }
    
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

public class HeaderRequestEnhancer: RequestEnhancer {
    
    public let priority: Int = DEFAULT_ENHANCER_PRIORITY
    
    public func canEnhance(request: Request, modifier: RequestModifier) -> Bool {
        return modifier is Header
    }
    
    public func enhanceRequest(inout request: Request, modifier: RequestModifier) {
        switch(modifier) {
        case let header as Header:
            request.addHeader(header)
        default:
            break
        }
    }
    
    public func deenhanceResponse(response: Response<NSData?>, modifier: RequestModifier) -> Response<NSData?> {
        return response
    }
    
}