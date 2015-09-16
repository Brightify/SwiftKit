//
//  EventData.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/17/15.
//
//

import Foundation

/**
    EventData is a struct that is being used to pass data through listeners and to create them.

    :param: SENDER Type of the object that fired this event.
    :param: INPUT Type of the data that will be sent in the event.
*/
public struct EventData<SENDER, INPUT> {
    
    /// Object that fires the event.
    public let sender: SENDER
    
    /// Data passed to the listeners.
    public let input: INPUT

    public func map<NEW_SENDER, NEW_INPUT>(transformation: (sender: SENDER, input: INPUT) -> (sender: NEW_SENDER, input: NEW_INPUT)) -> EventData<NEW_SENDER, NEW_INPUT> {
        let newData = transformation(sender: sender, input: input)
        return EventData<NEW_SENDER, NEW_INPUT>(sender: newData.sender, input: newData.input)
    }
    
    public func mapSender<NEW_SENDER>(transformation: SENDER -> NEW_SENDER) -> EventData<NEW_SENDER, INPUT> {
        let newSender = transformation(sender)
        return EventData<NEW_SENDER, INPUT>(sender: newSender, input: input)
    }
    
    public func mapInput<NEW_INPUT>(transformation: INPUT -> NEW_INPUT) -> EventData<SENDER, NEW_INPUT> {
        let newInput = transformation(input)
        return EventData<SENDER, NEW_INPUT>(sender: sender, input: newInput)
    }
    
}