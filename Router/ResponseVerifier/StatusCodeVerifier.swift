//
//  StatusCodeVerifier.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 04.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public final class StatusCodeVerifier: ResponseVerifier {
    
    private let codes: Set<Int>
    
    public init(codes: [Int]) {
        self.codes = Set(codes)
    }
    
    public convenience init(code: Int...) {
        self.init(codes: code)
    }
    
    public convenience init(range: CountableClosedRange<Int>) {
        self.init(codes: range.map { $0 })
    }
    
    public func verify(response: Response<SupportedType>) -> Bool {
        return response.statusCode.map { codes.contains($0.rawValue) } ?? false
    }
}
