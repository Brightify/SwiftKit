//
//  RequestLogging.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 04.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct RequestLogging: OptionSet, RequestModifier {
    
    public static let requestUrl = RequestLogging(rawValue: 1 << 0)
    public static let time = RequestLogging(rawValue: 1 << 1)
    public static let responseCode = RequestLogging(rawValue: 1 << 2)
    
    public static let requestHeaders = RequestLogging(rawValue: 1 << 3)
    public static let requestBody = RequestLogging(rawValue: 1 << 4)
    
    public static let responseHeaders = RequestLogging(rawValue: 1 << 5)
    public static let responseBody = RequestLogging(rawValue: 1 << 6)
    
    public static let all = RequestLogging(rawValue: Int.max)
    public static let disabled = RequestLogging(rawValue: 0)
    
    public let rawValue: Int
    
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
    
    public init(_ requestLogging: RequestLogging...) {
        self.init(requestLogging)
    }
    
    public init(_ requestLogging: [RequestLogging]) {
        rawValue = requestLogging.reduce(RequestLogging.disabled) { acc, element in acc.union(element) }.rawValue
    }
}
