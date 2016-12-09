//
//  ResponseVerifier.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 14/07/15.
//  Copyright © 2015 Brightify. All rights reserved.
//

public protocol ResponseVerifier {

    func verify(response: Response<SupportedType>) -> Bool
}
