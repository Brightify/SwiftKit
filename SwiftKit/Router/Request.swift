//
//  Request.swift
//  Pods
//
//  Created by Tadeas Kriz on 27/07/15.
//
//

import Foundation

public struct Request {
    
    fileprivate var backingURLRequest: NSMutableURLRequest
    
    public var urlRequest: URLRequest {
        return backingURLRequest as URLRequest
    }
    
    public var URL: Foundation.URL? {
        get {
            return backingURLRequest.url
        }
        set {
            backingURLRequest.url = newValue
        }
    }
    
    public var cachePolicy: NSURLRequest.CachePolicy {
        get {
            return backingURLRequest.cachePolicy
        }
        set {
            backingURLRequest.cachePolicy = newValue
        }
    }
    
    public var timeoutInterval: TimeInterval {
        get {
            return backingURLRequest.timeoutInterval
        }
        set {
            backingURLRequest.timeoutInterval = newValue
        }
    }
    
    public var networkServiceType: NSURLRequest.NetworkServiceType {
        get {
            return backingURLRequest.networkServiceType
        }
        set {
            backingURLRequest.networkServiceType = newValue
        }
    }
    
    public var allowsCellularAccess: Bool {
        get {
            return backingURLRequest.allowsCellularAccess
        }
        set {
            backingURLRequest.allowsCellularAccess = newValue
        }
    }
    
    public var HTTPMethod: String {
        get {
            return backingURLRequest.httpMethod
        }
        set {
            backingURLRequest.httpMethod = newValue
        }
    }
    
    public var allHTTPHeaderFields: [String: String]? {
        get {
            return backingURLRequest.allHTTPHeaderFields
        }
        set {
            backingURLRequest.allHTTPHeaderFields = newValue
        }
    }
    
    public var HTTPBody: Data? {
        get {
            return backingURLRequest.httpBody
        }
        set {
            backingURLRequest.httpBody = newValue
        }
    }
    
    public var HTTPBodyStrem: InputStream? {
        get {
            return backingURLRequest.httpBodyStream
        }
        set {
            backingURLRequest.httpBodyStream = newValue
        }
    }
    
    public var HTTPShouldHandleCookies: Bool {
        get {
            return backingURLRequest.httpShouldHandleCookies
        }
        set {
            backingURLRequest.httpShouldHandleCookies = newValue
        }
    }
    
    public var HTTPShouldUsePipelining: Bool {
        get {
            return backingURLRequest.httpShouldUsePipelining
        }
        set {
            backingURLRequest.httpShouldUsePipelining = newValue
        }
    }
    
    public var modifiers: [RequestModifier] = []
    public var enhancedBy: [RequestEnhancer] = []
    
    public init(URL: Foundation.URL) {
        backingURLRequest = NSMutableURLRequest(url: URL)
    }
    
    public init(URL: Foundation.URL, cachePolicy: NSURLRequest.CachePolicy, timeoutInterval: TimeInterval) {
        backingURLRequest = NSMutableURLRequest(url: URL, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    public mutating func addHeader(_ header: Header) {
        backingURLRequest.addHeader(header)
    }
    
    public mutating func setHeader(_ header: Header) {
        backingURLRequest.setHeader(header)
    }
    
    public mutating func getMutableURLRequest() -> NSMutableURLRequest {
        return backingURLRequest
    }
    
}
