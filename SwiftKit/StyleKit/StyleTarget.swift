//
//  StyleTarget.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 07/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

struct StyleTarget {
    let type: Styleable.Type
    let names: [String]
    
    func matches(item: StyledItem) -> Bool {
        guard type.isSupertypeOf(item.styleable.dynamicType) else {
            return false
        }
        // Cross match names, if any matches, the target matches as well.
        guard names.isEmpty || names.reduce(false, combine: { $0 || item.styleable.names.contains($1) }) else {
            return false
        }
        
        return true
    }
}

extension StyleTarget: Hashable {
    var hashValue: Int {
        return 31 + ObjectIdentifier(type).hashValue + names.reduce(31) { $0 + $1.hashValue }
    }
}

func == (lhs: StyleTarget, rhs: StyleTarget) -> Bool {
    return lhs.type == rhs.type &&
        lhs.names.count == rhs.names.count &&
        lhs.names.sort() == rhs.names.sort()
    
}