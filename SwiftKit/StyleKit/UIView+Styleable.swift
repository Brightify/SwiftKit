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
    
    public var stylingHandler: StylingHandler {
        get {
            return associatedObject(self, key: &stylingHandlerKey) { [weak self] in StylingHandler(styledItem: self) }
        }
    }
    
    public var parent: Styleable? {
        return superview
    }
    
    public var children: [Styleable] {
        return subviews.map { $0 }
    }
}
