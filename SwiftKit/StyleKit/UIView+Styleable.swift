//
//  UIView+Styleable.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 07/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

import UIKit

private var stylingHandlerKey: UInt8 = 0
extension UIView: Styleable {
    
    public var skt_stylingDetails: StylingDetails {
        get {
            return associatedObject(self, key: &stylingHandlerKey) { [weak self] in StylingDetails(styledItem: self) }
        }
    }
    
    public var skt_parent: Styleable? {
        return superview
    }
    
    public var skt_children: [Styleable] {
        return subviews.map { $0 }
    }
}

extension NSObject {
    
    internal class func skt_swizzleInstanceSelector(originalSelector: Selector, withNewSelector newSelector: Selector) {
        let originalMethod = class_getInstanceMethod(self, originalSelector)
        let newMethod = class_getInstanceMethod(self, newSelector)
        
        let methodAdded = class_addMethod(
            self,
            originalSelector,
            method_getImplementation(newMethod),
            method_getTypeEncoding(newMethod))
        
        if methodAdded {
            class_replaceMethod(
                self,
                newSelector,
                method_getImplementation(originalMethod),
                method_getTypeEncoding(originalMethod))
        } else {
            method_exchangeImplementations(originalMethod, newMethod)
        }
    }
}

// MARK: - Swizzle methods
extension UIView {
    public override class func initialize() {
        struct Static {
            static var token: dispatch_once_t = 0
        }
        
        // Do not run for subclasses
        if self !== UIView.self {
            return
        }
        
        dispatch_once(&Static.token) {
            skt_swizzleInstanceSelector("willMoveToSuperview:", withNewSelector: "skt_willMoveToSuperview:")
            skt_swizzleInstanceSelector("didMoveToSuperview", withNewSelector: "skt_didMoveToSuperview")

            skt_swizzleInstanceSelector("willMoveToWindow:", withNewSelector: "skt_willMoveToWindow:")
            skt_swizzleInstanceSelector("didMoveToWindow", withNewSelector: "skt_didMoveToWindow")
        }
    }
    
    // MARK: Methods for swizzling
    
    func skt_willMoveToSuperview(newSuperview: UIView?) {
        skt_willMoveToSuperview(newSuperview)
        
        if newSuperview != nil && newSuperview != superview {
            skt_stylingDetails.invalidateCachedStyles()
            UIKitStyleManager.instance.scheduleStyleApplicationIfNeeded(self, animated: false)
        }
    }
    
    func skt_didMoveToSuperview() {
        skt_didMoveToSuperview()
        
        if superview != nil {
            UIKitStyleManager.instance.applyIfScheduled(self)
        }
    }
    
    func skt_willMoveToWindow(newWindow: UIWindow?) {
        skt_willMoveToWindow(newWindow)
        
        if newWindow != nil && newWindow != window {
            skt_stylingDetails.invalidateCachedStyles()
            UIKitStyleManager.instance.scheduleStyleApplicationIfNeeded(self, animated: false)
        }
    }
    
    func skt_didMoveToWindow() {
        skt_didMoveToWindow()
        
        if window != nil {
            UIKitStyleManager.instance.applyIfScheduled(self)
        }
    }
}
