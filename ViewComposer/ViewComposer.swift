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

/**
* Operator that adds view to the parent and creates it if it is nil
* :param: viewOrNil The view to be added to the parent
* :param: parent The parent view which will be used as a target view for viewOrNil addition
*/
public func => <VIEW_TYPE: UIView>(inout viewOrNil: VIEW_TYPE!, parent: UIView) {
    viewOrNil = viewComposerOperator(viewOrNil, parent)
}

/**
* Operator that adds view to the parent and creates it if it is nil
* :param: viewOrNil The view to be added to the parent
* :param: parent The parent view which will be used as a target view for viewOrNil addition
*/
public func => <VIEW_TYPE: UIView>(inout viewOrNil: VIEW_TYPE?, parent: UIView) {
    viewOrNil = viewComposerOperator(viewOrNil, parent)
}

private func viewComposerOperator<VIEW_TYPE: UIView>(viewOrNil: VIEW_TYPE?, parent: UIView) -> VIEW_TYPE {
    if let view = viewOrNil {
        if (view === parent) {
            fatalError("Cannot add view to itself!")
        }
        
        view.removeFromSuperview()
        parent.addSubview(view)
        return view
    } else {
        return ViewComposer.compose(VIEW_TYPE).addInto(parent)
    }
}

/**
* ViewComposer is a utility class that should provide the best experience with creating views, 
* adding them into superview and assigning listeners to them
*/
public class ViewComposer {
    
    private init() {
    }
    
    public class func compose<T: UIView>(type: T.Type) -> AddIntoSuperview<T> {
        var view = T()
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        return AddIntoSuperview(view: view)
    }
}

/// Because Swift compiler fails when using tupple and generics, we need this class to overcome it.
public class AddIntoSuperview<T: UIView> {
    
    public let view: T
    
    private init(view: T) {
        self.view = view
    }
    
    public func addInto(superview: UIView) -> T {
        superview.addSubview(view)
        return view
    }
    
}