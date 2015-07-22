//
//  UIBarButtonItemEventTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 02.07.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
import SwiftKit
import performSelector_swift

class UIBarButtonItemEventTest: QuickSpec {
    
    override func spec() {
        describe("UIBarButtonItem") {
            it("calls selected event") {
                let button = UIBarButtonItem(title: "", style: .Plain)
                var calledTimes = 0
                button.selected += { _ in
                    calledTimes++
                }
                
                button.target?.swift_performSelector(button.action, withObject: nil)
                
                expect(calledTimes) == 1
            }
        }
    }
    
}