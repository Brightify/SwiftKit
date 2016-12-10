//
//  MockRequestPerformer.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 28/07/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import SwiftKit
import HTTPStatusCodes
import SwiftKitStaging

public typealias MockEndpoint = (method: String, url: String, response: String, statusCode: Int)

public class MockRequestPerformer: RequestPerformer {
    
    public var endpoints: [MockEndpoint] = []
    public var delay: Double = 0.1
    
    public func perform(request: Request, completion: @escaping (Response<Data?>) -> Void) -> Cancellable {
        let endpoint = endpoints
            .filter { $0.method == request.HTTPMethod && $0.url == request.URL?.absoluteString }.first
        
        let response: Response<Data?>
        if let endpoint = endpoint {
            let responseData = endpoint.response.data(using: String.Encoding.utf8)
            response = Response(
                output: responseData,
                statusCode: HTTPStatusCode(rawValue: endpoint.statusCode),
                error: nil,
                request: request,
                rawResponse: nil,
                rawData: responseData)
        } else {
            response = Response(
                output: nil,
                statusCode: HTTPStatusCode(rawValue: 404),
                error: nil,
                request: request,
                rawResponse: nil,
                rawData: nil)
        }
     
        let cancellable = MockCancellable()

        DispatchQueue.main.asyncAfter(deadline: .now() + 0.1) {
            if (!cancellable.cancelled) {
                completion(response)
            }
        }
        
        return cancellable
    }
}

class MockCancellable: Cancellable {
    
    var cancelled = false
    
    func cancel() {
        cancelled = true
    }
    
}
