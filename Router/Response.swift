//
//  Response.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

import Foundation

public typealias EmptyResponse = Response<Void>

public class Response<T> {
    
    public let output: T
    public let statusCode: Int?
    public let error: NSError?
    public let rawRequest: NSURLRequest
    public let rawResponse: NSURLResponse?
    public let rawData: NSData?
    
    public init(output: T, statusCode: Int?, error: NSError?, rawRequest: NSURLRequest, rawResponse: NSURLResponse?, rawData: NSData?) {
        self.output = output
        self.statusCode = statusCode
        self.error = error
        self.rawRequest = rawRequest
        self.rawResponse = rawResponse
        self.rawData = rawData
    }
    
    public func emptyCopy() -> EmptyResponse {
        return EmptyResponse(output: Void(), statusCode: statusCode, error: error,
            rawRequest: rawRequest, rawResponse: rawResponse, rawData: rawData)
    }
}