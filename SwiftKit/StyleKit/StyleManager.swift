//
//  StyleManager.swift
//  SwiftManager
//
//  Created by Tadeas Kriz on 06/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public class StyleManager {
    
    private var canonicalTypes: [Styleable.Type] = []
    
    private var index: UInt = 1
    private var styles: [ObjectIdentifier: [Style]] = [:]
    
    public init(@noescape _ run: CollapsibleStyleBuilder -> ()) {
        let stylingStarted = NSDate()
        let builder = BaseStyleBuilder(part: .Initial(manager: self))
        run(builder)
        print("Styled in", NSDate().timeIntervalSinceDate(stylingStarted), "seconds")
    }
    
    public func apply(styleable: Styleable, includeChildren: Bool = true, animated: Bool = false) {
        styleable.stylingHandler.scheduledStyleApplication?.cancel()
        styleable.stylingHandler.scheduledStyleApplication = nil
        
        styleable.stylingHandler.manager = self
        
        let stylesToApply: [Style]
        if let cachedStyles = styleable.stylingHandler.cachedStyles {
            stylesToApply = cachedStyles
        } else {
            let item = styledItem(styleable)
            let identifier = ObjectIdentifier(item.canonicalType)
            
            guard let typeStyles = styles[identifier] else { return }
            
            stylesToApply = typeStyles.map { (precedence: $0.precedence(self, item: item), style: $0) }
                .filter { $0.precedence != Style.nonMatchingPrecedence }
                .sort { $0.precedence < $1.precedence }
                .map { $0.style }
            
            styleable.stylingHandler.cachedStyles = stylesToApply
        }
        styleable.stylingHandler.beforeStyled?()
        
        style(styleable, styles: stylesToApply, animated: animated)
        
        styleable.stylingHandler.afterStyled?()
        
        if includeChildren {
            for child in styleable.children {
                apply(child, includeChildren: true, animated: animated)
            }
        }
    }
    
    public func scheduleStyleApplication(styleable: Styleable, includeChildren: Bool = true, animated: Bool) {
        styleable.stylingHandler.scheduledStyleApplication = cancellableDispatchAsync {
            self.apply(styleable, includeChildren: includeChildren, animated: animated)
        }
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
        guard let canonical = canonicalTypeOf(item.dynamicType) else {
            fatalError("Unsupported styleable! Make sure it has a canonical superclass!")
        }
        return StyledItem(canonicalType: canonical, styleable: item)
    }
    
    private func canonicalTypeOf(type: Styleable.Type) -> Styleable.Type? {
        var currentType: AnyClass? = type
        while let unwrappedType = currentType where !canonicalTypes.contains({ $0 == unwrappedType }) {
            currentType = unwrappedType.superclass()
        }
        return currentType as? Styleable.Type
    }
}
