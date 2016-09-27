//
//  Response.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

import Foundation
import HTTPStatusCodes

/// Response with no output data
public typealias EmptyResponse = Response<Void>

/**
    Response with generic type of output

    :param: T output type
*/
open class Response<T> {
    
    /// Output of the Reponse
    open let output: T
    
    /// Status code of the API request
    open let statusCode: HTTPStatusCode?
    
    /// Error of the API request
    open let error: Error?
    
    /// Request that was used to obtain this response
    open let request: Request
    
    /// Raw API response
    open let rawResponse: URLResponse?
    
    /// Raw data of the response
    open let rawData: Data?
    
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
    
    /**
        Constructs a copy of Response with response type of Void
    
        :returns: Copy of Response with response type of Void
    */
    open func emptyCopy() -> EmptyResponse {
        return map { _ in Void() }
    }
    
    open func map<U>(_ transform: (T) -> U) -> Response<U> {
        return Response<U>(output: transform(output), statusCode: statusCode, error: error, request: request, rawResponse: rawResponse, rawData: rawData)
    }
}
