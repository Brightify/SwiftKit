//
//  PolymorphicInfo.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 26.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol PolymorphicInfo {
    
    var type: Polymorphic.Type { get }
    
    var name: String { get }
    
    var registeredSubtypes: [Polymorphic.Type] { get }
}
