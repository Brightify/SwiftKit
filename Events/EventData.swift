//
//  EventData.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/17/15.
//
//

import Foundation

/**
* EventData is a struct that is being used to pass data through listeners and to create them.
*/
public struct EventData<SENDER, INPUT> {
    
    /**
    * Object that registers the listeners
    */
    public let sender: SENDER
    
    /**
    * Variable containing meaningful data passed through the listeners
    */
    public let input: INPUT

}