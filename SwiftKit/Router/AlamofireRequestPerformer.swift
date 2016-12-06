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
    
    public func perform(request: Request, completion: @escaping (Response<Data?>) -> ()) -> Cancellable {
        let alamofireRequest = Alamofire
            .request(request.urlRequest)
            .responseData {
                let response = Response<Data?>(
                    output: $0.result.value,
                    statusCode: $0.response?.statusCodeValue,
                    error: $0.result.error,
                    request: request,
                    rawResponse: $0.response,
                    rawData: $0.result.value)
                
                completion(response)
        }
        
        return Cancellable {
            alamofireRequest.cancel()
        }
    }
}
