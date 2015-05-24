//
//  EventsTest.swift
//  SwiftKit
//
//  Created by Tadeáš Kříž on 5/24/15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Foundation

import UIKit
import XCTest
import SwiftKit

class EventsTest: XCTestCase {
    
    func testInjection() {
        
        let event = Event<EventsTest, Void>()
        
        event.fire(self, input: Void())
        
        var timesFired = 0
        event += { _ in
            timesFired++
        }
        
        event.fire(self, input: Void())
        
        XCTAssertEqual(timesFired, 1)
    }
    
    
    
}