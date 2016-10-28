//
//  ObjectMapper.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 28.10.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

public struct ObjectMapper {
    
    private let polymorph: Polymorph?
    
    public init(polymorph: Polymorph? = nil) {
        self.polymorph = polymorph
    }
    
    public func serialize<T: Serializable>(_ value: T?) -> SupportedType {
        
    }
    
    public func serialize<T: Serializable>(_ array: [T]?) -> SupportedType {
        
    }
    
    public func serialize<T: Serializable>(_ dictionary: [String: T]?) -> SupportedType {
        
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType) -> T? {
        
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType, discardAllOnError: Bool = true) -> [T]? {
        
    }
    
    public func deserialize<T: Deserializable>(_ type: SupportedType, discardAllOnError: Bool = true) -> [String: T]? {
        
    }
}
