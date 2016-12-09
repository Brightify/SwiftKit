//
//  StatusCodeRangeVerifier.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 04.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public final class StatusCodeRangeVerifier: ResponseVerifier {
    
    private let range: ClosedRange<Int>
    
    public init(range: ClosedRange<Int>) {
        self.range = range
    }
    
    public func verify(response: Response<SupportedType>) -> Bool {
        return response.statusCode.map { range.contains($0.rawValue) } ?? false
    }
}
