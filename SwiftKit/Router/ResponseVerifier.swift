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

public class StatusCodeRangeVerifier: ResponseVerifier {
    
    private let range: Range<Int>
    
    public init(range: Range<Int>) {
        self.range = range
    }
    
    public func verify<T>(response: Response<T>) -> Bool {
        return response.statusCode >= range.startIndex && response.statusCode <= range.endIndex
    }
    
}