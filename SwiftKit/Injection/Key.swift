//
//  Key.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 13/10/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

/**
Key is used in Key based injection

- parameter T: The parameter is the class type this Key is assigned to
*/
public class Key<T> {
    
    /// Name of the key
    public let name: String
    
    /**
    Initializes key with name
    
    - parameter named: The name of the key
    */
    public init(named: String) {
        name = named
    }
}