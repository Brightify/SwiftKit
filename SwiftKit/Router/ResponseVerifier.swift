//
//  ResponseVerifier.swift
//  Pods
//
//  Created by Tadeas Kriz on 14/07/15.
//
//

import Foundation

public protocol ResponseVerifier {

    func verify<T>(response: Response<T>) -> Bool
    
}

open class StatusCodeRangeVerifier: ResponseVerifier {
    
    fileprivate let range: ClosedRange<Int>
    
    public init(range: ClosedRange<Int>) {
        self.range = range
    }
    
    open func verify<T>(response: Response<T>) -> Bool {
        return response.statusCode.map { range.contains($0.rawValue) } ?? false
    }
    
}
