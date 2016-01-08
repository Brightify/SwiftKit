//
//  OffspringChain.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 07/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

struct StyleBlueprint {
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
    
    func collapse(var prestyle: StyleBlueprint) {
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
    
    func collapse<T: Styleable, S: SequenceType
        where S.Generator.Element == String>(type: T.Type, names: S, styling: T -> ())
    {
        let target = StyleTarget(type: type, names: Set(names))
        let typeErasedStyling = Style.typeEraseStylingFunction(styling)
        let prestyle = StyleBlueprint(firstTarget: target, styling: typeErasedStyling)
        
        collapse(prestyle)
    }
}

public struct BaseStyleBuilder: CollapsibleStyleBuilder {

    let part: StylePart
    
    public func style<T: Styleable>(type: T.Type, named names: String..., styling: T -> ()) {
        part.collapse(type, names: names, styling: styling)
    }
    
    public func inside(type: Styleable.Type, names: Set<String>) -> CollapsibleStyleBuilder {
        let parent = StyleTarget(type: type, names: names)
        let nextPart = StylePart.Parent(previous: self.part, parent: parent)
        
        return BaseStyleBuilder(part: nextPart)
    }
}

// Not used. See StyleBuilder.swift
struct TypedStyleBuilder<T: Styleable> /*: BoundCollapsibleStyleBuilder */ {
    
    let part: StylePart
    
    func style(type: T.Type, named names: String..., styling: T -> ()) {
        part.collapse(type, names: names, styling: styling)
    }
    
    func inside(type: Styleable.Type, names: Set<String>) -> TypedStyleBuilder {
        let parent = StyleTarget(type: type, names: names)
        let nextPart = StylePart.Parent(previous: self.part, parent: parent)
        
        return TypedStyleBuilder(part: nextPart)
    }
    
}