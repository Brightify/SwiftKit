//
//  Endpoint.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 05.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

open class Endpoint<IN, OUT> {
    
    open class var method: HTTPMethod {
        return .get
    }
    
    public let path: String
    public let inputEncoding: InputEncoding
    public let modifiers: [RequestModifier]
    
    public final var method: HTTPMethod {
        return type(of: self).method
    }
    
    public required init(_ path: String, modifiers: [RequestModifier]) {
        self.path = path
        self.inputEncoding = type(of: self).method.defaultInputEncoding
        self.modifiers = modifiers
    }
    
    public required init(_ path: String, inputEncoding: InputEncoding, modifiers: [RequestModifier]) {
        self.path = path
        self.inputEncoding = inputEncoding
        self.modifiers = modifiers
    }
}

extension Endpoint {
    
    public convenience init(_ path: String, modifiers: RequestModifier...) {
        self.init(path, modifiers: modifiers)
    }
    
    public convenience init(_ path: String, inputEncoding: InputEncoding, modifiers: RequestModifier...) {
        self.init(path, inputEncoding: inputEncoding, modifiers: modifiers)
    }
}
