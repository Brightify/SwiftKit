//
//  RequestLogger.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 27/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public struct RequestLoggingOptions: OptionSet {
    
    public static let RequestUrl = RequestLoggingOptions(rawValue: 1)
    public static let RequestHeaders = RequestLoggingOptions(rawValue: 2)
    public static let RequestBody = RequestLoggingOptions(rawValue: 4)
    
    public static let ResponseHeaders = RequestLoggingOptions(rawValue: 8)
    public static let ResponseCode = RequestLoggingOptions(rawValue: 16)
    public static let ResponseBody = RequestLoggingOptions(rawValue: 32)
    
    public static let All: RequestLoggingOptions = [RequestUrl, RequestHeaders, RequestBody, ResponseHeaders, ResponseCode, ResponseBody]
    public static let Disabled: RequestLoggingOptions = []
    
    public let rawValue: Int
    public init(rawValue: Int) {
        self.rawValue = rawValue
    }
}

public struct RequestLogging: RequestModifier {
    public static let All: RequestLogging = RequestLogging(RequestLoggingOptions.All)
    public static let Disabled: RequestLogging = RequestLogging(RequestLoggingOptions.Disabled)
    
    public let options: RequestLoggingOptions
    
    public init(_ options: RequestLoggingOptions) {
        self.options = options
    }
}

open class RequestLogger: RequestEnhancer {
    open let priority: Int = 0
    open let defaultOptions: RequestLoggingOptions
    
    fileprivate var pendingRequests: [(request: Request, time: Date)] = []
    
    public convenience init() {
        self.init(defaultOptions: [.RequestUrl, .ResponseCode])
    }
    
    public init(defaultOptions: RequestLoggingOptions) {
        self.defaultOptions = defaultOptions
    }
    
    open func canEnhance(request: Request) -> Bool {
        let options = extractLoggingOptions(request)
        return options == nil || options?.isEmpty == false
    }
    
    open func enhance(request: inout Request) {
        pendingRequests.append((request, Date()))
    }
    
    open func deenhance(response: Response<Data?>) -> Response<Data?> {
        let possibleMatchedRequest = pendingRequests.index { $0.request.urlRequest == response.request.urlRequest }
            .map { pendingRequests.remove(at: $0) }
        guard let matchedRequest = possibleMatchedRequest else { return response }
        let request = matchedRequest.request
        let options = extractLoggingOptions(request) ?? defaultOptions
        let elapsedTime = String(format: "%.2fs", arguments: [-matchedRequest.time.timeIntervalSinceNow])
        let url = request.URL?.absoluteString ?? "<< unknown URL >>"
        if !options.isEmpty {
            print("----- Begin of request log -----")
        }
        if options.contains(.RequestUrl) {
            print("\n\(request.HTTPMethod) \(url) took \(elapsedTime)")
        }
        if let statusCode = response.statusCode , options.contains(.ResponseCode) {
            print("\nResponse status code: \(statusCode)")
        }
        if options.contains(.RequestHeaders) {
            print("\nRequest headers:")
            request.allHTTPHeaderFields?.forEach { name, value in
                print("\t\(name): \(value)")
            }
        }
        if let requestBody = request.HTTPBody.flatMap({ NSString(data: $0 as Data, encoding: String.Encoding.utf8.rawValue) }) , options.contains(.RequestBody) {
            print("\n>>> Request body: \(requestBody)")
        }
        if let httpResponse = response.rawResponse as? HTTPURLResponse , options.contains(.ResponseHeaders) {
            print("\nResponse headers:")
            httpResponse.allHeaderFields.forEach { name, value in
                print("\t\(name): \(value)")
            }
        }
        if let responseBody = response.rawData.flatMap({ NSString(data: $0 as Data, encoding: String.Encoding.utf8.rawValue) }) , options.contains(.ResponseBody) {
            print("\n<<< Response body: \(responseBody)")
        }
        if !options.isEmpty {
            print("----- End of request log -----")
        }

        return response
    }

    func extractLoggingOptions(_ request: Request) -> RequestLoggingOptions? {
        let modifiers = request.modifiers.map { $0 as? RequestLogging }.filter { $0 != nil }.map { $0! }
        return modifiers.count > 0 ? modifiers.reduce([] as RequestLoggingOptions) { $0.union($1.options) } : nil
    }
}
