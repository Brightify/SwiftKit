//
//  Injectable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 5/24/15.
//
//

import Foundation

public protocol Injectable: class {
    
    init(injector: Injector)
    
}