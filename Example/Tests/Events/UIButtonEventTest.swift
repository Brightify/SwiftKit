//
//  UIButtonEventTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 02.07.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
import SwiftKit

class UIButtonEventTest: QuickSpec {
    
    override func spec() {
        describe("UIButton") {
            it("calls touchDown event") {
                let button = UIButton()
                var calledTimes = 0
                button.touchDown += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.TouchDown)
                
                expect(calledTimes) == 1
            }
            
            it("calls touchDownRepeat event") {
                let button = UIButton()
                var calledTimes = 0
                button.touchDownRepeat += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.TouchDownRepeat)
                
                expect(calledTimes) == 1
            }
            
            it("calls touchDragInside event") {
                let button = UIButton()
                var calledTimes = 0
                button.touchDragInside += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.TouchDragInside)
                
                expect(calledTimes) == 1
            }
            
            it("calls touchDragOutside event") {
                let button = UIButton()
                var calledTimes = 0
                button.touchDragOutside += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.TouchDragOutside)
                
                expect(calledTimes) == 1
            }
            
            it("calls touchDragEnter event") {
                let button = UIButton()
                var calledTimes = 0
                button.touchDragEnter += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.TouchDragEnter)
                
                expect(calledTimes) == 1
            }
            
            it("calls touchDragExit event") {
                let button = UIButton()
                var calledTimes = 0
                button.touchDragExit += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.TouchDragExit)
                
                expect(calledTimes) == 1
            }
            
            it("calls touchUpInside event") {
                let button = UIButton()
                var calledTimes = 0
                button.touchUpInside += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.TouchUpInside)
                
                expect(calledTimes) == 1
            }
            
            it("calls touchUpOutside event") {
                let button = UIButton()
                var calledTimes = 0
                button.touchUpOutside += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.TouchUpOutside)
                
                expect(calledTimes) == 1
            }
            
            it("calls valueChanged event") {
                let button = UIButton()
                var calledTimes = 0
                button.valueChanged += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.ValueChanged)
                
                expect(calledTimes) == 1
            }
            
            it("calls editingDidBegin event") {
                let button = UIButton()
                var calledTimes = 0
                button.editingDidBegin += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.EditingDidBegin)
                
                expect(calledTimes) == 1
            }
            
            it("calls editingChanged event") {
                let button = UIButton()
                var calledTimes = 0
                button.editingChanged += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.EditingChanged)
                
                expect(calledTimes) == 1
            }
            
            it("calls editingDidEnd event") {
                let button = UIButton()
                var calledTimes = 0
                button.editingDidEnd += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.EditingDidEnd)
                
                expect(calledTimes) == 1
            }
            
            it("calls editingDidEndOnExit event") {
                let button = UIButton()
                var calledTimes = 0
                button.editingDidEndOnExit += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.EditingDidEndOnExit)
                
                expect(calledTimes) == 1
            }
            
            it("calls allTouchEvents event") {
                let button = UIButton()
                var calledTimes = 0
                button.allTouchEvents += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.AllTouchEvents)
                
                expect(calledTimes) == 1
            }
            
            it("calls allEditingEvents event") {
                let button = UIButton()
                var calledTimes = 0
                button.allEditingEvents += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.AllEditingEvents)
                
                expect(calledTimes) == 1
            }
            
            it("calls allEvents event") {
                let button = UIButton()
                var calledTimes = 0
                button.allEvents += { _ in
                    calledTimes++
                }
                
                button.sendActionsForControlEvents(.AllEvents)
                
                expect(calledTimes) == 1
            }
        }
    }
    
}