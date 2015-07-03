//
//  TestUtils.swift
//  SwiftKit
//
//  Created by Filip Dolník on 27.06.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import XCTest
import SwiftKit

public class TestUtils: BaseTestUtils {
    
    public class func assertDeinit(@noescape instanceFactory: () -> Deinitializable) {
        XCTAssertTrue(wasDeinit(instanceFactory), "Deinit wasn't called.")
    }
}
