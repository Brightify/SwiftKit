//
//  Wrapper.swift
//  Pods
//
//  Created by Filip Dolník on 25.05.15.
//
//

import Foundation

class Wrapper<T>: NSData {
    
    let data: T
    
    init(data: T) {
        self.data = data
        
        super.init()
    }
    
}