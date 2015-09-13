//
//  AlamofireRequestPerformer.swift
//  Pods
//
//  Created by Tadeas Kriz on 28/07/15.
//
//

import Alamofire

public struct AlamofireRequestPerformer: RequestPerformer {
    
    public func performRequest(request: Request, completion: Response<NSData?> -> ()) -> Cancellable {
        let alamofireRequest = Alamofire.Manager.sharedInstance
            .request(request.urlRequest)
            .responseData { (urlRequest, httpResponse, result) -> () in
                let statusCode = httpResponse?.statusCode
                
                let response = Response<NSData?>(output: result.value, statusCode: statusCode, error: result.error, request: request, rawResponse: httpResponse, rawData: result.value)
                
                completion(response)
        }
        
        return CancellableToken {
            alamofireRequest.cancel()
        }
    }
    
}
