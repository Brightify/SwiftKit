//
//  RequestLogger.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 27/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

import Foundation

public final class RequestLogger: RequestEnhancer {
    
    private let defaultOptions: RequestLogging
    
    public init(defaultOptions: RequestLogging = [.requestUrl, .responseCode, .time]) {
        self.defaultOptions = defaultOptions
    }
    
    public func enhance(request: inout Request) {
        request.modifiers.append(RequestLoggerTimestamp(time: Date()))
    }
    
    public func deenhance(response: Response<SupportedType>) {
        let modifiers = response.request.modifiers.flatMap { $0 as? RequestLogging }
        guard modifiers.count > 0 else { return }
        
        let options = modifiers.reduce(RequestLogging.disabled) { acc, element in acc.union(element) }
        guard !options.isEmpty else { return }
        
        print("----- Begin of request log -----")
        
        if options.contains(.requestUrl) {
            let url = response.request.url?.absoluteString ?? "<< unknown URL >>"
            print("\nRequest url: \(response.request.httpMethod.rawValue) \(url)")
        }
        
        if options.contains(.time) {
            print("\nTime: ", terminator: "")
            if let timestamp = response.request.modifiers.flatMap({ $0 as? RequestLoggerTimestamp }).first {
                print(String(format: "%.2fs", arguments: [-timestamp.time.timeIntervalSinceNow]))
            } else {
                print("unknown")
            }
        }
        
        if options.contains(.responseCode) {
            print("\nResponse status code: ", terminator: "")
            if let statusCode = response.statusCode?.rawValue {
                print(statusCode)
            } else {
                print("unknown")
            }
        }
        
        if options.contains(.requestHeaders) {
            print("\nRequest headers:", terminator: "")
            if let headers = response.request.allHTTPHeaderFields, !headers.isEmpty {
                print("")
                headers.forEach { name, value in
                    print("\t\(name): \(value)")
                }
            } else {
                print(" empty")
            }
        }
        
        if options.contains(.requestBody) {
            print("\n Request body: ", terminator: "")
            if let requestBody = response.request.httpBody.flatMap({ NSString(data: $0 as Data, encoding: String.Encoding.utf8.rawValue) }) {
                print(requestBody)
            } else {
                print("empty")
            }
        }
        
        if options.contains(.responseHeaders) {
            print("\nResponse headers:", terminator: "")
            if let headers = (response.rawResponse as? HTTPURLResponse)?.allHeaderFields, !headers.isEmpty {
                print("")
                headers.forEach { name, value in
                    print("\t\(name): \(value)")
                }
            } else {
                print(" empty")
            }
        }
        
        if options.contains(.responseBody) {
            print("\n Response body: ", terminator: "")
            if let responseBody = response.rawData.flatMap({ NSString(data: $0 as Data, encoding: String.Encoding.utf8.rawValue) }) {
                print(responseBody)
            } else {
                print(" empty")
            }
        }
        
        print("----- End of request log -----")
    }
}
