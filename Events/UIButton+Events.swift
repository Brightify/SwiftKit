//
//  UIButton+events.swift
//  o3-meeting-assistant-ios
//
//  Created by Tadeáš Kříž on 5/17/15.
//  Copyright (c) 2015 Brightify. All rights reserved.
//

import UIKit

/// Extension of UIControl that adds Events of every possible action eg. ".TouchDown", ".ValueChanged"
extension UIControl {
    
    private struct AssociatedKey {
        static var eventMap = "eventMap"
    }
    
    private class EventMapWrapper {
        var events:[Selector: Event<UIControl, UIEvent>] = [:]
    }
    
    /// A touch-down event in the control.
    public var touchDown: Event<UIControl, UIEvent> {
        return events_getEvent("events_touchDown:forEvent:", forEvents: .TouchDown)
    }

    /// A repeated touch-down event in the control. For this event the value of the UITouch tapCount method is greater 
    /// than one.
    public var touchDownRepeat: Event<UIControl, UIEvent> {
        return events_getEvent("events_touchDownRepeat:forEvent:", forEvents: .TouchDownRepeat)
    }
    
    /// An event where a finger is dragged inside the bounds of the control.
    public var touchDragInside: Event<UIControl, UIEvent> {
        return events_getEvent("events_touchDragInside:forEvent:", forEvents: .TouchDragInside)
    }
    
    /// An event where a finger is dragged just outside the bounds of control.
    public var touchDragOutside: Event<UIControl, UIEvent> {
        return events_getEvent("events_touchDragOutside:forEvent:", forEvents: .TouchDragOutside)
    }
    
    /// An event where a finger is dragged into the bounds of the control.
    public var touchDragEnter: Event<UIControl, UIEvent> {
        return events_getEvent("events_touchDragEnter:forEvent:", forEvents: .TouchDragEnter)
    }
    
    /// An event where a finger is dragged from within a control to outside its bounds.
    public var touchDragExit: Event<UIControl, UIEvent> {
        return events_getEvent("events_touchDragExit:forEvent:", forEvents: .TouchDragExit)
    }
    
    /// A touch-up event in the control where the finger is inside the bounds of the control.
    public var touchUpInside: Event<UIControl, UIEvent> {
        return events_getEvent("events_touchUpInside:forEvent:", forEvents: .TouchUpInside)
    }
    
    /// A touch-up event in the control where the finger is outside the bounds of the control.
    public var touchUpOutside: Event<UIControl, UIEvent> {
        return events_getEvent("events_touchUpOutside:forEvent:", forEvents: .TouchUpOutside)
    }
    
    /// A system event canceling the current touches for the control.
    public var touchCancel: Event<UIControl, UIEvent> {
        return events_getEvent("events_touchCancel:forEvent:", forEvents: .TouchCancel)
    }
    
    /// A touch dragging or otherwise manipulating a control, causing it to emit a series of different values.
    public var valueChanged: Event<UIControl, UIEvent> {
        return events_getEvent("events_valueChanged:forEvent:", forEvents: .ValueChanged)
    }

    /// A touch initiating an editing session in a `UITextField` object by entering its bounds.
    public var editingDidBegin: Event<UIControl, UIEvent> {
        return events_getEvent("events_editingDidBegin:forEvent:", forEvents: .EditingDidBegin)
    }
    
    /// A touch making an editing change in a `UITextField` object.
    public var editingChanged: Event<UIControl, UIEvent> {
        return events_getEvent("events_editingChanged:forEvent:", forEvents: .EditingChanged)
    }
    
    /// A touch ending an editing session in a `UITextField` object by leaving its bounds.
    public var editingDidEnd: Event<UIControl, UIEvent> {
        return events_getEvent("events_editingDidEnd:forEvent:", forEvents: .EditingDidEnd)
    }
    
    /// A touch ending an editing session in a `UITextField` object.
    public var editingDidEndOnExit: Event<UIControl, UIEvent> {
        return events_getEvent("events_editingDidEndOnExit:forEvent:", forEvents: .EditingDidEndOnExit)
    }
    
    /// All touch events.
    public var allTouchEvents: Event<UIControl, UIEvent> {
        return events_getEvent("events_allTouchEvents:forEvent:", forEvents: .AllTouchEvents)
    }
    
    /// All editing touches for UITextField objects
    public var allEditingEvents: Event<UIControl, UIEvent> {
        return events_getEvent("events_allEditingEvents:forEvent:", forEvents: .AllEditingEvents)
    }
    
    /// All events, including system events.
    public var allEvents: Event<UIControl, UIEvent> {
        return events_getEvent("events_allEvents:forEvent:", forEvents: .AllEvents)
    }
    
    func events_touchDown(sender: UIControl, forEvent event: UIEvent) {
        touchDown.fire(sender, input: event)
    }
    
    func events_touchDownRepeat(sender: UIControl, forEvent event: UIEvent) {
        touchDownRepeat.fire(sender, input: event)
    }
    
    func events_touchDragInside(sender: UIControl, forEvent event: UIEvent) {
        touchDragInside.fire(sender, input: event)
    }
    
    func events_touchDragOutside(sender: UIControl, forEvent event: UIEvent) {
        touchDragOutside.fire(sender, input: event)
    }
    
    func events_touchDragEnter(sender: UIControl, forEvent event: UIEvent) {
        touchDragEnter.fire(sender, input: event)
    }
    
    func events_touchDragExit(sender: UIControl, forEvent event: UIEvent) {
        touchDragExit.fire(sender, input: event)
    }
    
    func events_touchUpInside(sender: UIControl, forEvent event: UIEvent) {
        touchUpInside.fire(sender, input: event)
    }
    
    func events_touchUpOutside(sender: UIControl, forEvent event: UIEvent) {
        touchUpOutside.fire(sender, input: event)
    }
    
    func events_touchCancel(sender: UIControl, forEvent event: UIEvent) {
        touchCancel.fire(sender, input: event)
    }
    
    func events_valueChanged(sender: UIControl, forEvent event: UIEvent) {
        valueChanged.fire(sender, input: event)
    }
    
    func events_editingDidBegin(sender: UIControl, forEvent event: UIEvent) {
        editingDidBegin.fire(sender, input: event)
    }
    
    func events_editingChanged(sender: UIControl, forEvent event: UIEvent) {
        editingChanged.fire(sender, input: event)
    }
    
    func events_editingDidEnd(sender: UIControl, forEvent event: UIEvent) {
        editingDidEnd.fire(sender, input: event)
    }
    
    func events_editingDidEndOnExit(sender: UIControl, forEvent event: UIEvent) {
        editingDidEndOnExit.fire(sender, input: event)
    }
    
    func events_allTouchEvents(sender: UIControl, forEvent event: UIEvent) {
        allTouchEvents.fire(sender, input: event)
    }
    
    func events_allEditingEvents(sender: UIControl, forEvent event: UIEvent) {
        allEditingEvents.fire(sender, input: event)
    }
    
    func events_allEvents(sender: UIControl, forEvent event: UIEvent) {
        allTargets().forEach { print($0) }
        allEvents.fire(sender, input: event)
    }
    
    private func events_getEvent(action: Selector, forEvents controlEvents: UIControlEvents) -> Event<UIControl, UIEvent> {
        if let event = events_eventMapWrapper.events[action] {
            return event
        } else {
            let event = Event<UIControl, UIEvent>()
            addTarget(self, action: action, forControlEvents: controlEvents)
            events_eventMapWrapper.events[action] = event
            return event
        }
    }

    private var events_eventMapWrapper: EventMapWrapper {
        if let eventMapWrapper = objc_getAssociatedObject(self, &AssociatedKey.eventMap) as? EventMapWrapper {
            return eventMapWrapper
        } else {
            let eventMapWrapper = EventMapWrapper()
            objc_setAssociatedObject(self, &AssociatedKey.eventMap, eventMapWrapper, .OBJC_ASSOCIATION_RETAIN)
            return eventMapWrapper
        }
    }
    
}