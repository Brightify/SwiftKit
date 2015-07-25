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

}