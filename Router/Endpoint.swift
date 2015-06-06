//
//  Endpoint.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

import Foundation
import Alamofire

public protocol Endpoint {
    typealias Input
    typealias Output
    
    init(_ path: String)
    
    var method: Alamofire.Method { get }
    var path: String { get }
}