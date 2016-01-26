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
    
    public func performRequest(request: Request, completion: Response<NSData?> -> ()) -> Cancellable {
        let alamofireRequest = Alamofire.Manager.sharedInstance
            .request(request.urlRequest)
            .responseData {
                
                let response = Response<NSData?>(
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
