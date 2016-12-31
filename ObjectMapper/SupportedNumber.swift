//
//  SupportedNumber.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 30.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct SupportedNumber {
    
    public let int: Int?
    public let double: Double?
    
    public init(int: Int) {
        self.int = int
        self.double = nil
    }
    
    public init(double: Double) {
        self.int = nil
        self.double = double
    }
    
    public init(int: Int, double: Double) {
        self.int = int
        self.double = double
    }
}
