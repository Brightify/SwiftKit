//
//
//  ViewComposer.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/4/15.
//
//

import UIKit

infix operator => { }
infix operator >> { }

/**
    Operator that adds view to the parent and creates it if it is nil
    
    :param: viewOrNil The view to be added to the parent
    :param: parent The parent view which will be used as a target view for viewOrNil addition
*/
public func => <VIEW_TYPE: UIView>(inout viewOrNil: VIEW_TYPE!, parent: UIView) {
    viewOrNil = viewComposerOperator(viewOrNil, parent: parent)
}

/**
    Operator that adds view to the parent and creates it if it is nil

    :param: viewOrNil The view to be added to the parent
    :param: parent The parent view which will be used as a target view for viewOrNil addition
*/
public func => <VIEW_TYPE: UIView>(inout viewOrNil: VIEW_TYPE?, parent: UIView) {
    viewOrNil = viewComposerOperator(viewOrNil, parent: parent)
}

public func >> <VIEW_TYPE: UIView>(view: VIEW_TYPE, parent: UIView) {
    viewComposerOperator(view, parent: parent)
}

public func >> <VIEW_TYPE: UIView>(viewOrNil: VIEW_TYPE?, parent: UIView) {
    if let view = viewOrNil {
        viewComposerOperator(view, parent: parent)
    }
}

private func viewComposerOperator<VIEW_TYPE: UIView>(viewOrNil: VIEW_TYPE?, parent: UIView) -> VIEW_TYPE {
    let addInto: AddIntoSuperview<VIEW_TYPE>
    if let view = viewOrNil {
        if (view === parent) {
            fatalError("Cannot add view to itself!")
        }
        
        addInto = ViewComposer.configure(view)
    } else {
        addInto = ViewComposer.compose(VIEW_TYPE)
    }
    return addInto.addInto(parent)
}

/**
    ViewComposer is a utility class that should provide the best experience with creating views,
    adding them into superview and assigning listeners to them
*/
public class ViewComposer {
    
    private init() {
    }
    
    public class func configure<T: UIView>(view: T) -> AddIntoSuperview<T> {
        view.translatesAutoresizingMaskIntoConstraints = false
        return AddIntoSuperview(view: view)
    }
    
    public class func compose<T: UIView>(type: T.Type) -> AddIntoSuperview<T> {
        let view = T()
        return configure(view)
    }
}

// Because Swift compiler fails when using tupple and generics, we need this class to overcome it.
public class AddIntoSuperview<T: UIView> {
    
    public let view: T
    
    private init(view: T) {
        self.view = view
    }
    
    public func addInto(superview: UIView) -> T {
        view.removeFromSuperview()
        superview.addSubview(view)
        return view
    }
    
}