//
//  StylingHandler.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 08/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public class StylingHandler {
    public var names: [String] = [] {
        didSet {
            guard let manager = manager, styledItem = styledItem else { return }
            // When we change the names, we have to invalidate the style caches of this styleable and its children
            invalidateCachedStyles(reapply: false)
            manager.scheduleStyleApplication(styledItem, includeChildren: true, animated: true)
        }
    }
    public var beforeStyled: (Void -> Void)?
    public var afterStyled: (Void -> Void)?
    
    weak var styledItem: Styleable?
    weak var manager: StyleManager?
    
    var cachedStyles: [Style]? = nil
    
    var scheduledStyleApplication: Cancellable?
    
    public init(styledItem: Styleable?) {
        self.styledItem = styledItem
    }
    
    func invalidateCachedStyles(reapply reapply: Bool = true, includeChildren: Bool = true) {
        cachedStyles = nil
        
        if let styledItem = styledItem where includeChildren {
            // We have to pass in `reapply = false`, otherwise we would be doing a lot of unnecessary work
            styledItem.children.forEach { $0.stylingHandler.invalidateCachedStyles(reapply: false, includeChildren: true) }
        }
        
        if let styledItem = styledItem, manager = manager where reapply {
            manager.apply(styledItem, includeChildren: includeChildren, animated: false)
        }
    }
}