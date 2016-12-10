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
    
    public func perform(request: Request, completion: @escaping (Response<Data?>) -> Void) -> Cancellable {
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
/*

public func asResult() -> Observable<RouterResult<E.T>> {
    return asObservable().map { responseProtocol in
        let response = responseProtocol.response
        if let error = response.error {
            return .failure(.requestError(error, response.demap()))
        } else if response.statusCode?.isSuccess == false {
            return .failure(.invalidStatusCode(response.demap()))
        } else {
            return .success(response.output)
        }
    }
}


public func asResult() -> Observable<RouterResult<E.T.Wrapped>> {
    return asResult().map { (result: RouterResult<E.T>) in
        switch result {
        case .success(let maybeValue):
            if let value = maybeValue.value {
                return .success(value)
            } else {
                return .failure(.unknownError)
            }
        case .failure(let error):
            return .failure(error)
        }
    }
}*/
