//
//  URL+SupportedTypeConvertible.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

extension URL: SupportedTypeConvertible {
    
    public static var defaultTransformation = URLTransformation().typeErased()
}
