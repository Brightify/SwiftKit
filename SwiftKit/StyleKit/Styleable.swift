//
//  Styleable.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 07/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//


public protocol Styleable: class {
    var stylingHandler: StylingHandler { get }
    
    var names: [String] { get set }
    
    var parent: Styleable? { get }
    
    var children: [Styleable] { get }
}

public extension Styleable {
    var names: [String] {
        get {
            return stylingHandler.names
        }
        set {
            stylingHandler.names = newValue
        }
    }
}

extension Styleable {
    var manager: StyleManager? {
        return stylingHandler.manager
    }
    
    static func isSupertypeOf(type: Styleable.Type) -> Bool {
        return type is Self.Type
    }
    
    static func named(name: String) -> (type: Self.Type, named: String) {
        return (type: self, named: name)
    }
}