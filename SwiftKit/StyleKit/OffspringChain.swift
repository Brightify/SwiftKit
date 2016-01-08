//
//  OffspringChain.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 07/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

//public struct OffspringChain: StyleBuilder {
//    
//    let manager: StyleManager
//    let previous: [StyleTarget]
//    
//    public func style<T: Styleable>(type: T.Type, named names: String..., styling: T -> ()) {
//        let target = manager.styleTarget(type, named: names)
//        let typeErasedStyling = manager.typeEraseStylingFunction(styling)
//        
//        manager.appendStyle(target, inside: previous, styling: typeErasedStyling)
//    }
//    
//    public func inside(named name: String, _ otherNames: String...) -> StyleBuilder {
//        return inside(UIView.self, named: [name] + otherNames)
//    }
//    
//    public func inside(named name: String, _ otherNames: String..., _ run: (declare: StyleBuilder) -> ()) {
//        inside(UIView.self, named: [name] + otherNames, run)
//    }
//    
//    public func inside(type: Styleable.Type, named names: String...) -> StyleBuilder {
//        return inside(type, named: names)
//    }
//    
//    public func inside(type: Styleable.Type, named names: String..., _ run: (declare: StyleBuilder) -> ()) {
//        inside(type, named: names, run)
//    }
//    
//    private func inside(type: Styleable.Type, named names: [String]) -> StyleBuilder {
//        let target = manager.styleTarget(type, named: names)
//        return OffspringChain(manager: manager, previous: previous + [target])
//    }
//    
//    private func inside(type: Styleable.Type, named names: [String], _ run: (declare: StyleBuilder) -> ()) {
//        let target = manager.styleTarget(type, named: names)
//        let builder = OffspringChain(manager: manager, previous: previous + [target])
//        
//        run(declare: builder)
//    }
//}


struct PrestyleContainer {
    let styling: Styleable -> ()
    var chains: [StyleTarget: (target: StyleTarget, parents: [StyleTarget])] = [:]
    var currentTarget: StyleTarget {
        didSet {
            // Let's assume that everytime currentTarget is set, we don't know it yet. It should add some performance.
            chains[currentTarget] = (target: currentTarget, parents: [])
        }
    }
    var currentParents: [StyleTarget] {
        get {
            return chains[currentTarget]?.parents ?? []
        }
        set {
            chains[currentTarget]?.parents = newValue
        }
    }
    
    init(firstTarget: StyleTarget, styling: Styleable -> ()) {
        self.styling = styling
        
        currentTarget = firstTarget
        chains[firstTarget] = (target: firstTarget, parents: [])
    }
}

indirect enum StylePart {
    case Initial(manager: StyleManager)
    case Parent(previous: StylePart, parent: StyleTarget)
    case Join(previous: StylePart, target: StyleTarget)
    
    func collapse(var prestyle: PrestyleContainer) {
        switch self {
        case .Initial(let manager):
            prestyle.chains.values.forEach { style, parents in
                manager.appendStyle(style, inside: parents, styling: prestyle.styling)
            }
        case .Parent(let previous, let parent):
            prestyle.currentParents.append(parent)
            previous.collapse(prestyle)
        case .Join(let previous, let target):
            prestyle.currentTarget = target
            previous.collapse(prestyle)
        }
    }
    
    func collapse<T: Styleable>(type: T.Type, names: [String], styling: T -> ()) {
        let target = StyleTarget(type: type, names: names)
        let typeErasedStyling = Style.typeEraseStylingFunction(styling)
        let prestyle = PrestyleContainer(firstTarget: target, styling: typeErasedStyling)
        
        collapse(prestyle)
    }
}

public struct BaseStyleBuilder: CollapsibleStyleBuilder {

    let part: StylePart
    
    public func style<T: Styleable>(type: T.Type, named names: String..., styling: T -> ()) {
        part.collapse(type, names: names, styling: styling)
    }
    
//    public func style<T: Styleable>(type: T.Type, named names: String...) -> DSLHelper_Also<TypedStyleBuilder<T>> {
//        let target = StyleTarget(type: type, names: names)
//        let nextPart = StylePart.Join(previous: self.part, target: target)
//        let builder = TypedStyleBuilder<T>(part: nextPart)
//        
//        return DSLHelper_Also(also: builder)
//    }
    
    public func inside(type: Styleable.Type, names: [String]) -> CollapsibleStyleBuilder {
        let parent = StyleTarget(type: type, names: names)
        let nextPart = StylePart.Parent(previous: self.part, parent: parent)
        
        return BaseStyleBuilder(part: nextPart)
    }
}

// Not used. See StyleBuilder.swift
struct TypedStyleBuilder<T: Styleable> /*: BoundCollapsibleStyleBuilder */ {
    
    let part: StylePart
    
    func style(type: T.Type, named names: String...) -> DSLHelper_Also<TypedStyleBuilder> {
        let target = StyleTarget(type: type, names: names)
        let nextPart = StylePart.Join(previous: self.part, target: target)
        let builder = TypedStyleBuilder(part: nextPart)
        
        return DSLHelper_Also(also: builder)
    }
    
    func style(type: T.Type, named names: String..., styling: T -> ()) {
        part.collapse(type, names: names, styling: styling)
    }
    
    func inside(type: Styleable.Type, names: [String]) -> TypedStyleBuilder {
        let parent = StyleTarget(type: type, names: names)
        let nextPart = StylePart.Parent(previous: self.part, parent: parent)
        
        return TypedStyleBuilder(part: nextPart)
    }
    
}