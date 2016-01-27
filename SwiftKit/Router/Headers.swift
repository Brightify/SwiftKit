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
        case ApplicationFormUrlencoded
        case TextPlain
        case Custom(value: String)
        
        public var name: String {
            return "Content-Type"
        }
        
        public var value: String {
            switch self {
            case .ApplicationJson:
                return "application/json"
            case .ApplicationFormUrlencoded:
                return "application/x-www-form-urlencoded"
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
    
    public func canEnhance(request: Request) -> Bool {
        return request.modifiers.filter { $0 is Header }.count > 0
    }
    
    public func enhanceRequest(inout request: Request) {
        request.modifiers.map { $0 as? Header }.filter { $0 != nil }.forEach { request.addHeader($0!) }
    }
    
    public func deenhanceResponse(response: Response<NSData?>) -> Response<NSData?> {
        return response
    }
    
}