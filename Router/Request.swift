//
//  Request.swift
//  Pods
//
//  Created by Tadeas Kriz on 27/07/15.
//
//

import Foundation

public struct Request {
    
    private var backingURLRequest: NSMutableURLRequest
    
    public var urlRequest: NSURLRequest {
        return backingURLRequest
    }
    
    public var URL: NSURL? {
        get {
            return backingURLRequest.URL
        }
        set {
            backingURLRequest.URL = newValue
        }
    }
    
    public var cachePolicy: NSURLRequestCachePolicy {
        get {
            return backingURLRequest.cachePolicy
        }
        set {
            backingURLRequest.cachePolicy = newValue
        }
    }
    
    public var timeoutInterval: NSTimeInterval {
        get {
            return backingURLRequest.timeoutInterval
        }
        set {
            backingURLRequest.timeoutInterval = newValue
        }
    }
    
    public var networkServiceType: NSURLRequestNetworkServiceType {
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
            return backingURLRequest.HTTPMethod
        }
        set {
            backingURLRequest.HTTPMethod = newValue
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
    
    public var HTTPBody: NSData? {
        get {
            return backingURLRequest.HTTPBody
        }
        set {
            backingURLRequest.HTTPBody = newValue
        }
    }
    
    public var HTTPBodyStrem: NSInputStream? {
        get {
            return backingURLRequest.HTTPBodyStream
        }
        set {
            backingURLRequest.HTTPBodyStream = newValue
        }
    }
    
    public var HTTPShouldHandleCookies: Bool {
        get {
            return backingURLRequest.HTTPShouldHandleCookies
        }
        set {
            backingURLRequest.HTTPShouldHandleCookies = newValue
        }
    }
    
    public var HTTPShouldUsePipelining: Bool {
        get {
            return backingURLRequest.HTTPShouldUsePipelining
        }
        set {
            backingURLRequest.HTTPShouldUsePipelining = newValue
        }
    }
    
    public var modifiers: [RequestModifier] = []
    public var enhancedBy: [RequestEnhancer] = []
    
    public init(URL: NSURL) {
        backingURLRequest = NSMutableURLRequest(URL: URL)
    }
    
    public init(URL: NSURL, cachePolicy: NSURLRequestCachePolicy, timeoutInterval: NSTimeInterval) {
        backingURLRequest = NSMutableURLRequest(URL: URL, cachePolicy: cachePolicy, timeoutInterval: timeoutInterval)
    }
    
    public mutating func addHeader(header: Header) {
        backingURLRequest.addHeader(header)
    }
    
    public mutating func setHeader(header: Header) {
        backingURLRequest.setHeader(header)
    }
    
    public mutating func getMutableURLRequest() -> NSMutableURLRequest {
        return backingURLRequest
    }
    
}