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
        
        var view: UIView!
        var optionalView: UIView?
        var view1: UIView!
        var optionalView1: UIView?
        
        view = ViewComposer.compose(UIView).addInto(superview)
        optionalView = ViewComposer.compose(UIView).addInto(superview)
        
        XCTAssertNotNil(view)
        XCTAssertNotNil(optionalView)
        
        XCTAssertEqual(view.superview!, superview)
        XCTAssertEqual(optionalView!.superview!, superview)

        view1 => superview
        optionalView1 => superview
        
        
        XCTAssertNotNil(view1)
        XCTAssertNotNil(optionalView1)
        
        XCTAssertEqual(view1.superview!, superview)
        XCTAssertEqual(optionalView1!.superview!, superview)
        
    }

}
