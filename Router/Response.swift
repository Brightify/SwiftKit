//
//  Response.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

import Foundation

/// Response with no output data
public typealias EmptyResponse = Response<Void>

/**
* Response with generic type of output
* :param: T output type
*/
public class Response<T> {
    
    /// Output of the Reponse
    public let output: T
    
    /// Status code of the API request
    public let statusCode: Int?
    
    /// Error of the API request
    public let error: NSError?
    
    /// Raw API request
    public let rawRequest: NSURLRequest
    
    /// Raw API response
    public let rawResponse: NSURLResponse?
    
    /// Raw data of the response
    public let rawData: NSData?
    
    /**
    * Initializes Response
    * :param: output The output of the Response
    * :param: statusCode The status code of the Response
    * :param: error The Error of the API request
    * :param: rawRequest The raw request
    * :param: rawResponse The raw response
    * :param: rawData The raw data of the Response
    */
    public init(output: T, statusCode: Int?, error: NSError?, rawRequest: NSURLRequest, rawResponse: NSURLResponse?, rawData: NSData?) {
        self.output = output
        self.statusCode = statusCode
        self.error = error
        self.rawRequest = rawRequest
        self.rawResponse = rawResponse
        self.rawData = rawData
    }
    
    /**
    * Constructs a copy of Response with response type of Void
    * :returns: Copy of Response with response type of Void
    */
    public func emptyCopy() -> EmptyResponse {
        return map { _ in Void() }
    }
    
    public func map<U>(transform: T -> U) -> Response<U> {
        return Response<U>(output: transform(output), statusCode: statusCode, error: error, rawRequest: rawRequest, rawResponse: rawResponse, rawData: rawData)
    }
}