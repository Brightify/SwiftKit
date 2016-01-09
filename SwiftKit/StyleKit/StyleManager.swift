//
//  StyleManager.swift
//  SwiftManager
//
//  Created by Tadeas Kriz on 06/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public class StyleManager {
    private static var _instance: StyleManager?
    public class var instance: StyleManager {
        if let instance = _instance {
            return instance
        } else {
            let instance: StyleManager = self.init()
            _instance = instance
            return instance
        }
    }
    
    private var canonicalTypes: [Styleable.Type] = [] {
        didSet {
            canonicalTypesCache.removeAll(keepCapacity: true)
        }
    }
    private var canonicalTypesCache: [ObjectIdentifier: Styleable.Type] = [:]
    
    private var index: UInt = 1
    private var styles: [ObjectIdentifier: [Style]] = [:]
    
    public required init() { }
    
    public func declareStyles(@noescape run: CollapsibleStyleBuilder -> ()) {
        let stylingStarted = NSDate()
        let builder = BaseStyleBuilder(part: .Initial(manager: self))
        run(builder)
        print("Styled in", NSDate().timeIntervalSinceDate(stylingStarted), "seconds")
    }
    
    public func apply(styleable: Styleable, includeChildren: Bool = true, animated: Bool = false) {
        let stylingDetails = styleable.skt_stylingDetails
        stylingDetails.scheduledStyleApplication?.cancel()
        stylingDetails.scheduledStyleApplication = nil
        
        if stylingDetails.manager == nil {
            stylingDetails.manager = self
        }
        
        let stylesToApply: [Style]
        if let cachedStyles = stylingDetails.cachedStyles {
            stylesToApply = cachedStyles
        } else {
            let item = styledItem(styleable)
            let identifier = ObjectIdentifier(item.canonicalType)
            
            guard let typeStyles = styles[identifier] else { return }
            
            stylesToApply = typeStyles.map { (precedence: $0.precedence(self, item: item), style: $0) }
                .filter { $0.precedence != Style.nonMatchingPrecedence }
                .sort { $0.precedence < $1.precedence }
                .map { $0.style }
            
            stylingDetails.cachedStyles = stylesToApply
        }
        stylingDetails.beforeStyled?()
        
        style(styleable, styles: stylesToApply, animated: animated)
        
        stylingDetails.afterStyled?()
        
        if includeChildren {
            for child in styleable.skt_children {
                apply(child, includeChildren: true, animated: animated)
            }
        }
    }
    
    public func applyIfScheduled(styleable: Styleable) {
        let stylingDetails = styleable.skt_stylingDetails
        // If parent is scheduled, we don't want to trigger the child
        if stylingDetails.parentItemStylingDetails?.stylingScheduled ?? false {
            return
        }
        
        if let scheduledStyling = styleable.skt_stylingDetails.scheduledStyleApplication {
            apply(styleable, includeChildren: scheduledStyling.includeChildren, animated: scheduledStyling.animated)
        }
    }
    
    public func scheduleStyleApplication(styleable: Styleable, includeChildren: Bool = true, animated: Bool) {
        let cancellable = cancellableDispatchAsync {
            self.apply(styleable, includeChildren: includeChildren, animated: animated)
        }
        
        let scheduled = ScheduledStyling(includeChildren: includeChildren, animated: animated, cancellable: cancellable)
        styleable.skt_stylingDetails.scheduledStyleApplication = scheduled
    }
    
    public func scheduleStyleApplicationIfNeeded(styleable: Styleable, includeChildren: Bool = true, animated: Bool) {
        if !styleable.skt_stylingDetails.stylingScheduled {
            scheduleStyleApplication(styleable, includeChildren: includeChildren, animated: animated)
        }
    }
    
    public func clearCaches() {
        canonicalTypesCache = [:]
    }
    
    func style(styleable: Styleable, styles: [Style], animated: Bool) {
        // Default implementation does not support animations
        styles.forEach { $0.styling(styleable) }
    }
    
    func appendStyle(target: StyleTarget, inside: [StyleTarget], styling: Styleable -> ()) {
        if !canonicalTypes.contains({ $0 == target.type }) {
            canonicalTypes.append(target.type)
        }
        
        let identifier = ObjectIdentifier(target.type)
        let style = Style(index: index, inside: inside, target: target, styling: styling)
        if !styles.keys.contains(identifier) {
            styles[identifier] = []
        }
        styles[identifier]?.append(style)
        
        index += 1
    }
    
    func styledItem(item: Styleable) -> StyledItem {
        let canonical = canonicalTypeOf(item.dynamicType)
        return StyledItem(canonicalType: canonical, styleable: item)
    }
    
    class func destroyInstance() {
        _instance = nil
    }
    
    private func canonicalTypeOf(type: Styleable.Type) -> Styleable.Type {
        let cacheKey = ObjectIdentifier(type)
        if let cachedType = canonicalTypesCache[cacheKey] {
            return cachedType
        } else {
            let determinedType = determineCanonicalTypeOf(type)
            canonicalTypesCache[cacheKey] = determinedType
            return determinedType
        }
        
    }
    
    private func determineCanonicalTypeOf(type: Styleable.Type) -> Styleable.Type {
        var currentType: AnyClass? = type
        while let unwrappedType = currentType where !canonicalTypes.contains({ $0 == unwrappedType }) {
            currentType = unwrappedType.superclass()
        }
        return currentType as? Styleable.Type ?? type
    }
}
