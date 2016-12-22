//
//  AlamofireRequestPerformer.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 28/07/15.
//  Copyright © 2015 Brightify. All rights reserved.
//

import Alamofire
import HTTPStatusCodes

public struct AlamofireRequestPerformer: RequestPerformer {
    
    public let dataEncoder: DataEncoder
    
    public init(dataEncoder: DataEncoder = AlamofireJsonDataEncoder()) {
        self.dataEncoder = dataEncoder
    }
    
    public func perform(request: Request, callback: @escaping (Response<Data>) -> Void) -> Cancellable {
        let alamofireRequest = Alamofire.request(request.urlRequest).responseData {
            self.handleResponse(data: $0, request: request, callback: callback)
        }
        
        return Cancellable {
            alamofireRequest.cancel()
        }
    }
    
    private func handleResponse(data: DataResponse<Data>, request: Request, callback: (Response<Data>) -> Void) {
        let result: RouterResult<Data>
        // Alamofire uses different type of Result.
        switch data.result {
        case .success(let value):
            result = .success(value)
        case .failure(let error):
            result = .failure(.requestError(error))
        }
        
        let response = Response<Data>(
            result: result,
            statusCode: data.response?.statusCodeValue,
            rawResponse: data.response,
            rawData: data.data,
            request: request)
        
        callback(response)
    }
}
