//
//  String+SupportedTypeConvertible.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

extension String: SupportedTypeConvertible {
    
    public static var defaultTransformation = StringTransformation().typeErased()
}
