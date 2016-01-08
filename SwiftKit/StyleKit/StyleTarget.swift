//
//  StyleTarget.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 07/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

struct StyleTarget {
    let type: Styleable.Type
    let names: Set<String>
    
    func matches(item: StyledItem) -> Bool {
        guard type.isSupertypeOf(item.styleable.dynamicType) else {
            return false
        }
        // Cross match names, if any matches, the target matches as well.
        if !names.isEmpty && names.intersect(item.styleable.skt_names).isEmpty {
            return false
        }
        
        return true
    }
}

extension StyleTarget: Hashable {
    var hashValue: Int {
        var result = 17;

        result = 31 &* result &+ ObjectIdentifier(type).hashValue
        result = names.reduce(result) { 31 &* $0 &+ $1.hashValue }
        
        return result;
    }
}

func == (lhs: StyleTarget, rhs: StyleTarget) -> Bool {
    return lhs.type == rhs.type &&
        lhs.names.count == rhs.names.count &&
        lhs.names.sort() == rhs.names.sort()
    
}