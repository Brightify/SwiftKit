//
//  SupportedNumber+Equatable.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 30.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

extension SupportedNumber: Equatable {
}

public func ==(lhs: SupportedNumber, rhs: SupportedNumber) -> Bool {
    return lhs.int == rhs.int && lhs.double == rhs.double
}
