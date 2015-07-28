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
            .response { (urlRequest: NSURLRequest, httpResponse: NSHTTPURLResponse?, data: AnyObject?, error: NSError?) -> () in
                let statusCode = httpResponse?.statusCode
                
                let response = Response<NSData?>(output: data as? NSData, statusCode: statusCode, error: error, rawRequest: urlRequest, rawResponse: httpResponse, rawData: data as? NSData)
                
                completion(response)
        }
        
        return CancellableToken {
            alamofireRequest.cancel()
        }
    }
    
}
