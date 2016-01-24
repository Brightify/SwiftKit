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
import SwiftKitStaging

public struct AlamofireRequestPerformer: RequestPerformer {
    
    public func performRequest(request: Request, completion: Response<NSData?> -> ()) -> Cancellable {
        let alamofireRequest = Alamofire.Manager.sharedInstance
            .request(request.urlRequest)
            .responseData { (urlRequest, httpResponse, result) -> () in
                let response = Response<NSData?>(output: result.value, statusCode: httpResponse?.statusCodeValue,
                    error: result.error, request: request, rawResponse: httpResponse, rawData: result.value)
                
                completion(response)
        }
        
        return CancellableToken {
            alamofireRequest.cancel()
        }
    }
    
}
