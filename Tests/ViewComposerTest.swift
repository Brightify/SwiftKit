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
            
                expect(view.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                expect(optionalView?.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                
                expect(view.superview).to(equal(superview))
                expect(optionalView?.superview).to(equal(superview))
                
                expect(superview.subviews.count).to(equal(2))
            }
            
            it("composes view and adds into superview using operator api") {
                let superview = ViewComposer.compose(UIView).view
                
                var view: UIView!
                var optionalView: UIView?
                
                view => superview
                optionalView => superview
                
                expect(view).toNot(beNil())
                expect(optionalView).toNot(beNil())
                
                expect(view.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                expect(optionalView?.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                
                expect(view.superview).to(equal(superview))
                expect(optionalView?.superview).to(equal(superview))
                
                expect(superview.subviews.count).to(equal(2))
            }
            
            it("configures existing view and adds into superview using operator api") {
                let superview = ViewComposer.compose(UIView).view
                
                let view: UIView = UIView()
                let optionalView: UIView? = UIView()
                let implicitlyUnwrappedView: UIView! = UIView()
                
                view >> superview
                optionalView >> superview
                implicitlyUnwrappedView >> superview
                
                expect(view).toNot(beNil())
                expect(optionalView).toNot(beNil())
                expect(implicitlyUnwrappedView).toNot(beNil())
                
                expect(view.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                expect(optionalView?.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                expect(implicitlyUnwrappedView?.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                
                expect(view.superview).to(equal(superview))
                expect(optionalView?.superview).to(equal(superview))
                expect(implicitlyUnwrappedView?.superview).to(equal(superview))
                
                expect(superview.subviews.count).to(equal(3))
            }
            
            it("configures existing view and adds into superview using fluent api") {
                let superview = ViewComposer.compose(UIView).view
                
                let view: UIView = UIView()
                let optionalView: UIView? = UIView()
                let implicitlyUnwrappedView : UIView! = UIView()
                
                ViewComposer.configure(view).addInto(superview)
                ViewComposer.configure(optionalView!).addInto(superview)
                ViewComposer.configure(implicitlyUnwrappedView).addInto(superview)
                
                expect(view).toNot(beNil())
                expect(optionalView).toNot(beNil())
                expect(implicitlyUnwrappedView).toNot(beNil())
                
                expect(view.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                expect(optionalView?.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                expect(implicitlyUnwrappedView?.translatesAutoresizingMaskIntoConstraints).to(beFalse())
                
                expect(view.superview).to(equal(superview))
                expect(optionalView?.superview).to(equal(superview))
                expect(implicitlyUnwrappedView?.superview).to(equal(superview))
                
                expect(superview.subviews.count).to(equal(3))
            }
        }
    }

}
