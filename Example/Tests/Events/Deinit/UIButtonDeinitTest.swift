//
//  UIButtonDeinitTest.swift
//  SwiftKit
//
//  Created by Filip Dolník on 28.06.15.
//  Copyright (c) 2015 Tadeas Kriz. All rights reserved.
//

import Quick
import SwiftKit

class UIButtonDeinitTest: QuickSpec {
    
    override func spec() {
        describe("UIButton") {
            it("deinit") {
                QuickUtils.assertDeinit { TestableUIButton() }
            }
            
            it("deinit if touchDown is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.touchDown += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if touchDownRepeat is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.touchDownRepeat += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if touchDragInside is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.touchDragInside += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if touchDragOutside is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.touchDragOutside += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if touchDragEnter is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.touchDragEnter += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if touchDragExit is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.touchDragExit += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if touchUpInside is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.touchUpInside += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if touchUpOutside is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.touchUpOutside += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if valueChanged is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.valueChanged += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if editingDidBegin is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.editingDidBegin += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if editingChanged is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.editingChanged += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if editingDidEnd is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.editingDidEnd += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if editingDidEndOnExit is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.editingDidEndOnExit += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if allTouchEvents is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.allTouchEvents += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if allEditingEvents is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.allEditingEvents += { _ in
                        
                    }
                    return button
                }
            }
            
            it("deinit if allEvents is registered") {
                QuickUtils.assertDeinit {
                    let button = TestableUIButton()
                    button.allEvents += { _ in
                        
                    }
                    return button
                }
            }
        }
    }
    
}

private class TestableUIButton: UIButton, Deinitializable {
    
    let onDeinit = Event<Deinitializable, Void>()
    
    deinit {
        onDeinit.fire(self, input: Void())
    }
    
}