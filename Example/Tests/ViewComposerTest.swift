//
//  ViewComposerTest.swift
//  SwiftKit
//
//  Created by Tadeáš Kříž on 6/4/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import UIKit
import XCTest
import SwiftKit

class ViewComposerTest: XCTestCase {

    func testExample() {
        let superview = ViewComposer.compose(UIView).view
        
        let view = ViewComposer.compose(UIView).addInto(superview)
        
        XCTAssertEqual(view.superview!, superview)
        
        //ViewComposer.compose(UIView.self)
        
        //ViewComposer.compose(UIView)
        
    }

}
