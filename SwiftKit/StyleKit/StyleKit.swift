//
//  StyleKit.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 06/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

import UIKit


public protocol Styleable: class {
    
    var names: [String] { get set }
    
    var parent: Styleable? { get }
    
}

extension Styleable {
    static func isSupertypeOf(type: Styleable.Type) -> Bool {
        return type is Self
    }
}

extension UIView: Styleable {
    
    public var names: [String] {
        get {
            return []
        }
        set {
            
        }
    }
    
    public var parent: Styleable? {
        return superview
    }
}

class StyledView: UIView {
    private var _names: [String] = []
    override var names: [String] {
        get { return _names }
        set { _names = newValue }
    }
}

class NoncanonicalView: UIView { }






public protocol StyleBuilder {
    func style<T: Styleable>(type: T.Type, named names: String..., styling: T -> ())
    
    func inside(named name: String, _ otherNames: String...) -> StyleBuilder
    
    func inside(named name: String, _ otherNames: String..., _ run: (declare: StyleBuilder) -> ())
    
    func inside(type: Styleable.Type, named names: String...) -> StyleBuilder
    
    func inside(type: Styleable.Type, named names: String..., _ run: (declare: StyleBuilder) -> ())
}

struct StyleTarget {
    let canonicalType: Styleable.Type
    let names: [String]
    
    func matches(item: StyledItem) -> Bool {
        guard canonicalType.isSupertypeOf(item.styleable.dynamicType) else {
            return false
        }
        // Cross match names, if any matches, the target matches as well.
        guard names.isEmpty || names.reduce(false, combine: { $0 || item.styleable.names.contains($1) }) else {
            return false
        }
        
        return true
    }
}

struct StyledItem {
    let canonicalType: Styleable.Type
    let styleable: Styleable
    
    func getParent(manager: StyleKit) -> StyledItem? {
        return styleable.parent.map(manager.styledItem)
    }
}

public struct OffspringChain: StyleBuilder {
    
    let manager: StyleKit
    let previous: [StyleTarget]
    
    public func style<T: Styleable>(type: T.Type, named names: String..., styling: T -> ()) {
        let target = manager.styleTarget(type, named: names)
        let typeErasedStyling = manager.typeEraseStylingFunction(styling)
        
        manager.appendStyle(target, inside: previous, styling: typeErasedStyling)
    }
    
    public func inside(named name: String, _ otherNames: String...) -> StyleBuilder {
        return inside(UIView.self, named: [name] + otherNames)
    }
    
    public func inside(named name: String, _ otherNames: String..., _ run: (declare: StyleBuilder) -> ()) {
        inside(UIView.self, named: [name] + otherNames, run)
    }
    
    public func inside(type: Styleable.Type, named names: String...) -> StyleBuilder {
        return inside(type, named: names)
    }
    
    public func inside(type: Styleable.Type, named names: String..., _ run: (declare: StyleBuilder) -> ()) {
        inside(type, named: names, run)
    }
    
    private func inside(type: Styleable.Type, named names: [String]) -> StyleBuilder {
        let target = manager.styleTarget(type, named: names)
        return OffspringChain(manager: manager, previous: previous + [target])
    }
    
    private func inside(type: Styleable.Type, named names: [String], _ run: (declare: StyleBuilder) -> ()) {
        let target = manager.styleTarget(type, named: names)
        let builder = OffspringChain(manager: manager, previous: previous + [target])
        
        run(declare: builder)
    }
}

struct Style {
    static let nonMatchingPrecedence: UInt = 0
    
    let index: UInt
    let inside: [StyleTarget]
    let target: StyleTarget
    let styling: Styleable -> ()
    
    func precedence(manager: StyleKit, item: StyledItem) -> UInt {
        var precedence: UInt = 0
        if !target.names.isEmpty {
            if target.names.reduce(false, combine: { $0 || item.styleable.names.contains($1) }) {
                precedence += 100000
            } else {
                return Style.nonMatchingPrecedence
            }
        }
        
        if !inside.isEmpty {
            inside.count
            var currentItem: StyledItem? = item.getParent(manager)
            // We need to go up the tree
            for parent in inside.reverse() {
                while let unwrappedItem = currentItem {
                    if parent.matches(unwrappedItem) {
                        break
                    }
                    currentItem = unwrappedItem.getParent(manager)
                }
                
                if currentItem == nil {
                    return Style.nonMatchingPrecedence
                }
                
                currentItem = currentItem?.getParent(manager)
                precedence += 1000000
            }
            
        }
        
        // We need to do better with the precedence
        return precedence + index
    }
}

let started = NSDate()

public class StyleKit {
    
    private var canonicalTypes: [Styleable.Type] = []
    
    private var index: UInt = 1
    private var styles: [ObjectIdentifier: [Style]] = [:]
    
    public init(_ run: StyleBuilder -> ()) {
        let stylingStarted = NSDate()
        run(self)
        print("Styled in", NSDate().timeIntervalSinceDate(stylingStarted), "seconds")
    }
    
    public func apply<T: Styleable>(styleable: T) {
        let item = styledItem(styleable)
        let identifier = ObjectIdentifier(item.canonicalType)
        
        guard let typeStyles = styles[identifier] else { return }
        
        typeStyles.map { (precedence: $0.precedence(self, item: item), style: $0) }
            .filter { $0.precedence != Style.nonMatchingPrecedence }
            .sort { $0.precedence < $1.precedence }
            .forEach { $0.style.styling(styleable) }
    }
    
    func appendStyle(target: StyleTarget, inside: [StyleTarget], styling: Styleable -> ()) {
        let identifier = ObjectIdentifier(target.canonicalType)
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
    
    func styleTarget(type: Styleable.Type, named names: [String]) -> StyleTarget {
        if !canonicalTypes.contains({ $0 == type }) {
            canonicalTypes.append(type)
        }
        
        return StyleTarget(canonicalType: type, names: names)
    }
    
    func typeEraseStylingFunction<T: Styleable>(styling: T -> ()) -> Styleable -> () {
        let typeErasedStyling: Styleable -> () = { [weak self] in
            guard let castStyleable = $0 as? T else {
                fatalError("There is a bug in StyleKit. This should not be allowed! \(T.self) \(self?.canonicalTypes)")
            }
            styling(castStyleable)
        }
        
        return typeErasedStyling
    }
    
    private func canonicalTypeOf(type: Styleable.Type) -> Styleable.Type? {
        var currentType: AnyClass? = type
        while let unwrappedType = currentType where !canonicalTypes.contains({ $0 == unwrappedType }) {
            currentType = unwrappedType.superclass()
        }
        return currentType as? Styleable.Type
    }
}

extension StyleKit: StyleBuilder {
    public func style<T: Styleable>(type: T.Type, named names: String..., styling: T -> ()) {
        let target = styleTarget(type, named: names)
        let typeErasedStyling = typeEraseStylingFunction(styling)
        
        appendStyle(target, inside: [], styling: typeErasedStyling)
    }
    
    
    public func inside(named name: String, _ otherNames: String...) -> StyleBuilder {
        return inside(UIView.self, named: [name] + otherNames)
    }
    
    public func inside(named name: String, _ otherNames: String..., _ run: (declare: StyleBuilder) -> ()) {
        inside(UIView.self, named: [name] + otherNames, run)
    }
    
    public func inside(type: Styleable.Type, named names: String...) -> StyleBuilder {
        return inside(type, named: names)
    }
    
    public func inside(type: Styleable.Type, named names: String..., _ run: (declare: StyleBuilder) -> ()) {
        inside(type, named: names, run)
    }
    
    private func inside(type: Styleable.Type, named names: [String]) -> StyleBuilder {
        let target = styleTarget(type, named: names)
        return OffspringChain(manager: self, previous: [target])
    }
    
    private func inside(type: Styleable.Type, named names: [String], _ run: (declare: StyleBuilder) -> ()) {
        let target = styleTarget(type, named: names)
        let builder = OffspringChain(manager: self, previous: [target])
        
        run(declare: builder)
    }
}