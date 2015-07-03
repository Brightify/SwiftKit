//
//  BaseTestUtils.swift
//  SwiftKit
//
//  Created by Filip Dolník on 27.06.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import SwiftKit

public protocol Deinitializable {
    
    var onDeinit: Event<Deinitializable, Void> { get }

}

public class BaseTestUtils {

    public class func wasDeinit(@noescape instanceFactory: () -> Deinitializable) -> Bool {
        var instance: Deinitializable! = instanceFactory()
        var wasDeinitialized = false
        instance!.onDeinit += { _ in
            wasDeinitialized = true
        }
        instance = nil
        return wasDeinitialized
    }
}
