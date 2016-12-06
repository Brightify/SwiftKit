//
//  AcceptHeader.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 04.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

extension Headers {
    
    public enum Accept: Header {
        
        case applicationJson
        case textPlain
        case custom(value: String)
        
        public var name: String {
            return "Accept"
        }
        
        public var value: String {
            switch self {
            case .applicationJson:
                return "application/json"
            case .textPlain:
                return "text/plain"
            case .custom(let value):
                return value
            }
        }
    }
}
