//
//  ResponseProtocol.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 10.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Result
import HTTPStatusCodes

/// Protocol used as generic constraint in extensions.
public protocol ResponseProtocol {
    
    associatedtype T
    
    var result: RouterResult<T> { get }
    
    var request: Request  { get }
}

extension Response: ResponseProtocol {
}
