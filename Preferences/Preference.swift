//
//  Preference.swift
//  Pods
//
//  Created by Filip Dolník on 26.05.15.
//
//

import Foundation

public protocol Preference {
    
    typealias T
    
    var value: T { get set }
    
    var exists: Bool { get }
    
    init(key: String, defaultValue: T)
    
    func delete()
    
}