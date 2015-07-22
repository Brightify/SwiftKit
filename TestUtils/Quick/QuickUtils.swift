//
//  QuickUtils.swift
//  SwiftKit
//
//  Created by Filip Dolník on 27.06.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Nimble
import SwiftKit

public class QuickUtils: BaseTestUtils {
    
    public class func assertDeinit(instanceFactory: () -> Deinitializable) {
        expect(self.wasDeinit(instanceFactory)) == true
    }
}
