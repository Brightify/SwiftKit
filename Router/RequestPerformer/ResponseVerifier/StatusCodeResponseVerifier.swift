//
//  StatusCodeResponseVerifier.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 04.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct StatusCodeResponseVerifier: ResponseVerifier {
    
    private let codes: Set<Int>
    
    public init(codes: [Int]) {
        self.codes = Set(codes)
    }
    
    public init(code: Int...) {
        self.init(codes: code)
    }
    
    public init(range: CountableClosedRange<Int>) {
        self.init(codes: range.map { $0 })
    }
    
    public func verify(response: Response<SupportedType>) -> RouterError? {
        return response.statusCode.map { codes.contains($0.rawValue) } == false ? .invalidStatusCode : nil
    }
}
