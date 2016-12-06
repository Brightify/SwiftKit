//
//  Response.swift
//  SwiftKit
//
//  Created by Tadeáš Kříž on 6/6/15.
//  Copyright © 2015 Brightify. All rights reserved.
//

import Foundation
import HTTPStatusCodes

/**
    Response with generic type of output

    :param: T output type
*/
// TODO Struct?
public final class Response<T> {
    
    /// Output of the Reponse
    public let output: T
    
    /// Status code of the API request
    public let statusCode: HTTPStatusCode?
    
    /// Error of the API request
    public let error: Error?
    
    /// Request that was used to obtain this response
    public let request: Request
    
    /// Raw API response
    public let rawResponse: URLResponse?
    
    /// Raw data of the response
    public let rawData: Data?
    
    /**
        Initializes Response
    
        :param: output The output of the Response
        :param: statusCode The status code of the Response
        :param: error The Error of the API request
        :param: rawRequest The raw request
        :param: rawResponse The raw response
        :param: rawData The raw data of the Response
    */
    public init(output: T, statusCode: HTTPStatusCode?, error: Error?, request: Request, rawResponse: URLResponse?, rawData: Data?) {
        self.output = output
        self.statusCode = statusCode
        self.error = error
        self.request = request
        self.rawResponse = rawResponse
        self.rawData = rawData
    }
    
    public func map<U>(_ transform: (T) -> U) -> Response<U> {
        return Response<U>(output: transform(output), statusCode: statusCode, error: error, request: request, rawResponse: rawResponse, rawData: rawData)
    }
}
