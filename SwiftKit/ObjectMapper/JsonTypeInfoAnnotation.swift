//
//  JsonTypeInfoAnnotation.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/29/15.
//
//

import Foundation

@objc
public protocol JsonTypeInfoAnnotation {
    static func jsonTypeInfo() -> JsonTypeInfo
}