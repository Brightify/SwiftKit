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
    
    public func addHeader(_ header: Header) {
        addValue(header.value, forHTTPHeaderField: header.name)
    }
    
    public func setHeader(_ header: Header) {
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
        case applicationJson
        case textPlain
        case custom(value: String)
        
        public var name: String {
            return "Accept"
        }
        
        public var value: String {
            switch self {
            case .applicationJson:
                return "application/json"
            case .textPlain:
                return "text/plain"
            case .custom(let value):
                return value
            }
        }
    }
    
    public enum ContentType: Header {
        case applicationJson
        case applicationFormUrlencoded
        case textPlain
        case custom(value: String)
        
        public var name: String {
            return "Content-Type"
        }
        
        public var value: String {
            switch self {
            case .applicationJson:
                return "application/json"
            case .applicationFormUrlencoded:
                return "application/x-www-form-urlencoded"
            case .textPlain:
                return "text/plain"
            case .custom(let value):
                return value
            }
        }
    }
}

open class HeaderRequestEnhancer: RequestEnhancer {
    
    open let priority: Int = DEFAULT_ENHANCER_PRIORITY
    
    open func canEnhance(request: Request) -> Bool {
        return request.modifiers.filter { $0 is Header }.count > 0
    }
    
    open func enhance(request: inout Request) {
        request.modifiers.map { $0 as? Header }.filter { $0 != nil }.forEach { request.addHeader($0!) }
    }
    
    open func deenhance(response: Response<Data?>) -> Response<Data?> {
        return response
    }
    
}
