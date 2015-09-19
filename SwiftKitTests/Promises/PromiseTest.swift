//
//  PromiseTest.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/09/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import Nimble
@testable import SwiftKit

class PromiseTest: QuickSpec {
    
    override func spec() {
        describe("Promise") {
            it("works") {
                var process: Array<Int> = []
                
                var count: Int = 0
                
                promise { false } |> { "\($0)" } |> { $0 } |> { $0.characters.count } |> { [process] -> Int in
                        expect(process.count).to(equal(4))
                        process.enumerate().forEach { expect($0) == $1 }
                        return $0
                    } |> {
                        count = $0
                    }
                    expect(count).toEventually(equal(5), timeout: 5)
            }
            
            it("handles errors") {
                
                var error: ErrorType?
                
                promise {
                    throw NSError(domain: "hello", code: -100, userInfo: nil)
                }
                .onError {
                    error = $0
                }
                
                expect((error as? NSError)).toEventuallyNot(beNil())
                expect((error as? NSError)?.domain).toEventually(equal("hello"))
                expect((error as? NSError)?.code).toEventually(equal(-100))
            }
            
        }
    }
}