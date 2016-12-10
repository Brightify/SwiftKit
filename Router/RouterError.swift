//
//  RouterError.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 09.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

// TODO Review + better names.
public enum RouterError: Error {
    case invalidStatusCode()
    case requestError(Error)
    case customError(Error)
    case nilValue
    case unknownError
}
