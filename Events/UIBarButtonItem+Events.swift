//
//  UIBarButtonItem+Events.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/19/15.
//
//

import UIKit

/// Extension of UIBarButtonItem, that adds option to use closure instead of target and selector
extension UIBarButtonItem {
    
    private struct AssociatedKey {
        static var selectedEvent = "selectedEvent"
    }
    
    public var selected: Event<UIBarButtonItem, Void> {
        return prepareEvent()
    }
    
    public convenience init(image: UIImage?, style: UIBarButtonItemStyle, action: (EventData<UIBarButtonItem, Void> -> Void)? = nil) {
        self.init(image: image, style: style, target: nil, action: nil)
        
        registerAction(action)
    }
    
    public convenience init(image: UIImage?, landscapeImagePhone: UIImage?, style: UIBarButtonItemStyle, action: (EventData<UIBarButtonItem, Void> -> Void)? = nil) {
        self.init(image: image, landscapeImagePhone: landscapeImagePhone, style: style, target: nil, action: nil)
        
        registerAction(action)
    }
    
    public convenience init(title: String?, style: UIBarButtonItemStyle, action: (EventData<UIBarButtonItem, Void> -> Void)? = nil) {
        self.init(title: title, style: style, target: nil, action: nil)
        
        registerAction(action)
    }
    
    public convenience init(barButtonSystemItem systemItem: UIBarButtonSystemItem, action: (EventData<UIBarButtonItem, Void> -> Void)? = nil) {
        self.init(barButtonSystemItem: systemItem, target: nil, action: nil)
        
        registerAction(action)
    }
    
    func events_selectedAction(sender: UIBarButtonItem) {
        selected.fire(sender, input: Void())
    }
    
    private func registerAction(action: (EventData<UIBarButtonItem, Void> -> Void)?) {
        if let unwrappedAction = action {
            selected += unwrappedAction
        }
    }
    
    private func prepareEvent() -> Event<UIBarButtonItem, Void> {
        if let event = objc_getAssociatedObject(self, &AssociatedKey.selectedEvent) as? Event<UIBarButtonItem, Void> {
            return event
        } else {
            let event = Event<UIBarButtonItem, Void>()
            target = self
            action = "events_selectedAction:"
            objc_setAssociatedObject(self, &AssociatedKey.selectedEvent, event, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
            return event
        }
    }
}