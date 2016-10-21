//
//  SerializableData.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 21.10.16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

// data[xxx, yyy].get(using:, or:)
// data[xxx].get()
// data[xxx].set(x, using:)
// data[xxx].map(&x, using:, or:)

public struct SerializableData {
    
    private let data: SupportedType
    
    init(data: SupportedType) {
        self.data = data
    }
    
    public subscript(path: [String]) -> SerializableData {
        let type = path.reduce(data) { type, path in
            type.dictionary?[path] ?? .null
        }
        
        return SerializableData(data: type)
    }
    
    public subscript(path: String...) -> SerializableData {
        return self[path]
    }
}
