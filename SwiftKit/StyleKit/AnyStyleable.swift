//
//  AnyStyleable.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 08/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

/// Marker to be used as a wildcard. Can also be used as a type-erasing wrapper.
public class AnyStyleable: Styleable {
    private let wrapped: Styleable
    
    public var stylingHandler: StylingHandler {
        return wrapped.stylingHandler
    }
    
    public var names: [String] {
        get {
            return wrapped.names
        }
        set {
            wrapped.names = newValue
        }
    }
    public var parent: Styleable? {
        return wrapped.parent
    }
    public var children: [Styleable] {
        return wrapped.children
    }
    
    public init(_ wrapped: Styleable) {
        self.wrapped = wrapped
    }
}