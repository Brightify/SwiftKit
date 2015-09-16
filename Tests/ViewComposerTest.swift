//
//  ViewComposerTest.swift
//  SwiftKit
//
//  Created by Tadeáš Kříž on 6/4/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class ViewComposerTest: QuickSpec {

    override func spec() {
        describe("ViewComposer") {
            it("composes view and adds into super view using fluent api") {
                let superview = ViewComposer.compose(UIView).view

                var view: UIView!
                var optionalView: UIView?
                
                view = ViewComposer.compose(UIView).addInto(superview)
                optionalView = ViewComposer.compose(UIView).addInto(superview)
             
                expect(view).toNot(beNil())
                expect(optionalView).toNot(beNil())
            
                expect(view.superview).to(equal(superview))
                expect(optionalView?.superview).to(equal(superview))
            }
            
            it("composes view and adds into superview using operator api") {
                let superview = ViewComposer.compose(UIView).view
                
                var view: UIView!
                var optionalView: UIView?
                
                view => superview
                optionalView => superview
                
                expect(view).toNot(beNil())
                expect(optionalView).toNot(beNil())
                
                expect(view.superview).to(equal(superview))
                expect(optionalView?.superview).to(equal(superview))
            }
        }
    }

}
