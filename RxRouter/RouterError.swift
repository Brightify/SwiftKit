//
//  RouterError.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 09.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public enum RouterError: Error {
    case invalidStatusCode(Response<SupportedType>)
    case requestError(Error, Response<SupportedType>)
    case unknownError
}
