//
//  EventData.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/17/15.
//
//

import Foundation

public class EventData<SENDER, INPUT> {
    
    public let sender: SENDER
    public let input: INPUT
    
    public init(sender: SENDER, input: INPUT) {
        self.sender = sender
        self.input = input
    }
}