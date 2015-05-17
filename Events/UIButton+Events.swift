//
//  UIButton+Eventu.swift
//  o3-meeting-assistant-ios
//
//  Created by Tadeáš Kříž on 5/17/15.
//  Copyright (c) 2015 Brightify. All rights reserved.
//

import UIKit

extension UIControl {
    
    private struct AssociatedKey {
        static var eventMap = "eventMap"
    }
    
    private class EventMapWrapper {
        var events:[Selector: Event<UIControl, UIEvent>] = [:]
    }
    
    public var touchDown: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_touchDown:forEvent:", forEvents: .TouchDown)
    }

    public var touchDownRepeat: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_touchDownRepeat:forEvent:", forEvents: .TouchDownRepeat)
    }
    
    public var touchDragInside: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_touchDragInside:forEvent:", forEvents: .TouchDragInside)
    }
    
    public var touchDragOutside: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_touchDragOutside", forEvents: .TouchDragOutside)
    }
    
    public var touchDragEnter: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_touchDragEnter", forEvents: .TouchDragEnter)
    }
    
    public var touchDragExit: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_touchDragExit", forEvents: .TouchDragExit)
    }
    
    public var touchUpInside: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_touchUpInside:forEvent:", forEvents: .TouchUpInside)
    }
    
    public var touchUpOutside: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_touchUpOutside:forEvent:", forEvents: .TouchUpInside)
    }
    
    public var valueChanged: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_valueChanged:forEvent:", forEvents: .ValueChanged)
    }

    public var editingDidBegin: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_editingDidBegin:forEvent:", forEvents: .EditingDidBegin)
    }
    
    public var editingChanged: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_editingChanged:forEvent:", forEvents: .EditingChanged)
    }
    
    public var editingDidEnd: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_editingDidEnd:forEvent:", forEvents: .EditingDidEnd)
    }
    
    public var editingDidEndOnExit: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_editingDidEndOnExit:forEvent:", forEvents: .EditingDidEndOnExit)
    }
    
    public var allTouchEvents: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_allTouchEvents:forEvent:", forEvents: .AllTouchEvents)
    }
    
    public var allEditingEvents: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_allEditingEvents:forEvent:", forEvents: .AllEditingEvents)
    }
    
    public var allEvents: Event<UIControl, UIEvent> {
        return eventu_getEvent("eventu_allEvents:forEvent:", forEvents: .AllEvents)
    }
    
    func eventu_touchDown(sender: UIControl, forEvent event: UIEvent) {
        touchDown.fire(sender, input: event)
    }
    
    func eventu_touchDownRepeat(sender: UIControl, forEvent event: UIEvent) {
        touchDownRepeat.fire(sender, input: event)
    }
    
    func eventu_touchDragInside(sender: UIControl, forEvent event: UIEvent) {
        touchDragInside.fire(sender, input: event)
    }
    
    func eventu_touchDragOutside(sender: UIControl, forEvent event: UIEvent) {
        touchDragOutside.fire(sender, input: event)
    }
    
    func eventu_touchDragEnter(sender: UIControl, forEvent event: UIEvent) {
        touchDragEnter.fire(sender, input: event)
    }
    
    func eventu_touchDragExit(sender: UIControl, forEvent event: UIEvent) {
        touchDragExit.fire(sender, input: event)
    }
    
    func eventu_touchUpInside(sender: UIControl, forEvent event: UIEvent) {
        touchUpInside.fire(sender, input: event)
    }
    
    func eventu_touchUpOutside(sender: UIControl, forEvent event: UIEvent) {
        touchUpOutside.fire(sender, input: event)
    }
    
    func eventu_valueChanged(sender: UIControl, forEvent event: UIEvent) {
        valueChanged.fire(sender, input: event)
    }
    
    func eventu_editingDidBegin(sender: UIControl, forEvent event: UIEvent) {
        editingDidBegin.fire(sender, input: event)
    }
    
    func eventu_editingChanged(sender: UIControl, forEvent event: UIEvent) {
        editingChanged.fire(sender, input: event)
    }
    
    func eventu_editingDidEnd(sender: UIControl, forEvent event: UIEvent) {
        editingDidEnd.fire(sender, input: event)
    }
    
    func eventu_editingDidEndOnExit(sender: UIControl, forEvent event: UIEvent) {
        editingDidEndOnExit.fire(sender, input: event)
    }
    
    func eventu_allTouchEvents(sender: UIControl, forEvent event: UIEvent) {
        allTouchEvents.fire(sender, input: event)
    }
    
    func eventu_allEditingEvents(sender: UIControl, forEvent event: UIEvent) {
        allEditingEvents.fire(sender, input: event)
    }
    
    func eventu_allEvents(sender: UIControl, forEvent event: UIEvent) {
        allEvents.fire(sender, input: event)
    }
    
    private func eventu_getEvent(action: Selector, forEvents controlEvents: UIControlEvents) -> Event<UIControl, UIEvent> {
        if let event = eventu_eventMapWrapper.events[action] {
            return event
        } else {
            let event = Event<UIControl, UIEvent>()
            addTarget(self, action: action, forControlEvents: controlEvents)
            eventu_eventMapWrapper.events[action] = event
            return event
        }
    }

    private var eventu_eventMapWrapper: EventMapWrapper {
        if let eventMapWrapper = objc_getAssociatedObject(self, &AssociatedKey.eventMap) as? EventMapWrapper {
            return eventMapWrapper
        } else {
            let eventMapWrapper = EventMapWrapper()
            objc_setAssociatedObject(self, &AssociatedKey.eventMap, eventMapWrapper, objc_AssociationPolicy(OBJC_ASSOCIATION_RETAIN))
            return eventMapWrapper
        }
    }
    
}