//
//  StyleBuilder.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 07/01/16.
//  Copyright © 2016 Tadeas Kriz. All rights reserved.
//

public protocol StyleBuilder {

    func inside(type: Styleable.Type, names: Set<String>) -> CollapsibleStyleBuilder

}

public extension StyleBuilder {
    public func inside(names: Set<String>) -> CollapsibleStyleBuilder {
        return inside(AnyStyleable.self, names: names)
    }
    
    public func inside(named name: String, _ otherNames: String...) -> CollapsibleStyleBuilder {
        return inside(firstName: name, Set(otherNames))
    }
    
    public func inside(named name: String, _ otherNames: String..., _ run: (declare: CollapsibleStyleBuilder) -> ()) {
        let builder = inside(firstName: name, Set(otherNames))
        run(declare: builder)
    }
    
    public func inside(type: Styleable.Type, named names: String...) -> CollapsibleStyleBuilder {
        return inside(type, names: Set(names))
    }
    
    public func inside(type: Styleable.Type, named names: String..., _ run: (declare: CollapsibleStyleBuilder) -> ()) {
        let builder = inside(type, names: Set(names))
        run(declare: builder)
    }
    
    private func inside(firstName name: String, _ otherNames: Set<String>) -> CollapsibleStyleBuilder {
        return inside(otherNames.union([name]))
    }
}

public protocol CollapsibleStyleBuilder: StyleBuilder {
    
    func style<T: Styleable>(type: T.Type, named names: String..., styling: T -> ())
    
    // TODO I cannot find a way to do this in Swift currently. Maybe I am missing something
    // func style<T: Styleable>(type: T.Type, named names: String...) -> DSLHelper_Also<TypedStyleBuilder<T>>
}

public extension CollapsibleStyleBuilder {
    public func style(firstName name: String, named names: String..., styling: Styleable -> ()) {
        
    }
    
    public func style<T: Styleable>(type: T.Type, named names: String..., styling: T -> ()) {
        
    }
    
    
}

// Hopefully one day we will be able to return this from `style` in `CollapsibleStyleBuilder` and not the implementation.
public protocol BoundCollapsibleStyleBuilder: StyleBuilder {
    typealias TypeBinding: Styleable
    
    func style(type: TypeBinding.Type, named names: String..., styling: TypeBinding -> ())
    
    func style(type: TypeBinding.Type, named names: String...) -> DSLHelper_Also<Self>
}