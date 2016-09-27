//
//  AlamofireRequestPerformer.swift
//  Pods
//
//  Created by Tadeas Kriz on 28/07/15.
//
//

import Alamofire
import HTTPStatusCodes
import SwiftKitStaging

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
        
        return CancellableToken {
            alamofireRequest.cancel()
        }
    }
    
}
