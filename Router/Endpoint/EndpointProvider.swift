//
//  EndpointProvider.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 04.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public protocol EndpointProvider {
    
    static var implicitModifiers: [RequestModifier] { get }
}

extension EndpointProvider {
 
    public static var implicitModifiers: [RequestModifier] {
        return []
    }
}

extension EndpointProvider {
    
    public static func create<IN, OUT, T: Endpoint<IN, OUT>>(_ path: String, modifiers: [RequestModifier],
                       inType: IN.Type = IN.self, outType: OUT.Type = OUT.self) -> T {
        return T(path, modifiers: [modifiers, implicitModifiers].flatMap { $0 })
    }
    
    public static func create<IN, OUT, T: Endpoint<IN, OUT>>(_ path: String, inputEncoding: InputEncoding, modifiers: [RequestModifier],
                       inType: IN.Type = IN.self, outType: OUT.Type = OUT.self) -> T {
        return T(path, inputEncoding: inputEncoding, modifiers: [modifiers, implicitModifiers].flatMap { $0 })
    }
    
    public static func create<IN, OUT, T: Endpoint<IN, OUT>>(_ path: String,
                       inType: IN.Type = IN.self, outType: OUT.Type = OUT.self,
                       modifiers: RequestModifier...) -> T {
        return create(path, modifiers: modifiers)
    }
    
    public static func create<IN, OUT, T: Endpoint<IN, OUT>>(_ path: String, inputEncoding: InputEncoding,
                       inType: IN.Type = IN.self, outType: OUT.Type = OUT.self,
                       modifiers: RequestModifier...) -> T {
        return create(path, inputEncoding: inputEncoding, modifiers: modifiers)
    }
}
