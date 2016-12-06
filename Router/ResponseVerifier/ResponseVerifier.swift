//
//  ResponseVerifier.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 14/07/15.
//  Copyright © 2015 Brightify. All rights reserved.
//

// TODO ?
public protocol ResponseVerifier {

    func verify<T>(response: Response<T>) -> Bool
}
