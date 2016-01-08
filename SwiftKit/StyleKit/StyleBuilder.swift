//
//  StyleBuilder.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 07/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public protocol StyleBuilder {

    func inside(type: Styleable.Type, names: [String]) -> CollapsibleStyleBuilder

}

public extension StyleBuilder {
    func inside(names: [String]) -> CollapsibleStyleBuilder {
        return inside(AnyStyleable.self, names: names)
    }
    
    private func inside(firstName name: String, _ otherNames: [String]) -> CollapsibleStyleBuilder {
        return inside(otherNames.arrayByAdding(name))
    }
    
    func inside(named name: String, _ otherNames: String...) -> CollapsibleStyleBuilder {
        return inside(firstName: name, otherNames)
    }
    
    func inside(named name: String, _ otherNames: String..., _ run: (declare: CollapsibleStyleBuilder) -> ()) {
        let builder = inside(firstName: name, otherNames)
        run(declare: builder)
    }
    
    func inside(type: Styleable.Type, named names: String...) -> CollapsibleStyleBuilder {
        return inside(type, names: names)
    }
    
    func inside(type: Styleable.Type, named names: String..., _ run: (declare: CollapsibleStyleBuilder) -> ()) {
        let builder = inside(type, names: names)
        run(declare: builder)
    }
}

public protocol CollapsibleStyleBuilder: StyleBuilder {
    func style<T: Styleable>(type: T.Type, named names: String..., styling: T -> ())
    
    // TODO I cannot find a way to do this in Swift currently. Maybe I am missing something
    // func style<T: Styleable>(type: T.Type, named names: String...) -> DSLHelper_Also<TypedStyleBuilder<T>>
}

// Hopefully one day we will be able to return this from `style` in `CollapsibleStyleBuilder` and not the implementation.
public protocol BoundCollapsibleStyleBuilder: StyleBuilder {
    typealias TypeBinding: Styleable
    
    func style(type: TypeBinding.Type, named names: String..., styling: TypeBinding -> ())
    
    func style(type: TypeBinding.Type, named names: String...) -> DSLHelper_Also<Self>
}