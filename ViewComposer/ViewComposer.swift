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

public func => <VIEW_TYPE: UIView>(inout view: VIEW_TYPE!, parent: UIView) {
    if (view == parent) {
        fatalError("Cannot add view to itself!")
    }
    if (view == nil) {
        view = ViewComposer.compose(VIEW_TYPE).addInto(parent)
    } else {
        view.removeFromSuperview()
        parent.addSubview(view)
    }
}

public class ViewComposer {
    
    private init() {
    }
    
    public class func compose<T: UIView>(type: T.Type) -> AddIntoSuperview<T> {
        var view = T()
        view.setTranslatesAutoresizingMaskIntoConstraints(false)
        return AddIntoSuperview(view: view)
    }
}

/**
 * Because Swift compiler fails when using tupple and generics, we need this class to overcome it.
 */
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