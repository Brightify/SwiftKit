//
//  DeserializableData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public struct DeserializableData {
    
    private let data: SupportedType
    
    init(data: SupportedType) {
        self.data = data
    }
    
    public subscript(path: [String]) -> DeserializableData {
        let type = path.reduce(data) { type, path in
            type.dictionary?[path] ?? .null
        }
        
        return DeserializableData(data: type)
    }
    
    public subscript(path: String...) -> DeserializableData {
        return self[path]
    }
}
