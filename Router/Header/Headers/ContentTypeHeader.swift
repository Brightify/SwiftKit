//
//  ContentTypeHeader.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 04.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

extension Headers {
    
    public enum ContentType: Header {
        
        case applicationJson
        case applicationFormUrlencoded
        case textPlain
        case custom(value: String)
        
        public var name: String {
            return "Content-Type"
        }
        
        public var value: String {
            switch self {
            case .applicationJson:
                return "application/json"
            case .applicationFormUrlencoded:
                return "application/x-www-form-urlencoded"
            case .textPlain:
                return "text/plain"
            case .custom(let value):
                return value
            }
        }
    }
}
