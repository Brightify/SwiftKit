//
//  GlobalFunctions.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 13/10/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

import Foundation

internal func inferredType<T>() -> T.Type {
    return T.self
}

internal func associatedObject<T: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, @noescape initializer: () -> T) -> T {
    if let associated = objc_getAssociatedObject(base, key) as? T {
        return associated
    }
    
    let associated = initializer()
    objc_setAssociatedObject(base, key, associated, .OBJC_ASSOCIATION_RETAIN)
    return associated
}

internal func associateObject<T: AnyObject>(base: AnyObject, key: UnsafePointer<UInt8>, value: T) {
    objc_setAssociatedObject(base, key, value, .OBJC_ASSOCIATION_RETAIN)
}