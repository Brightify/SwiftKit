//
//  Endpoint.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

import Foundation
import Alamofire

/// Endpoint specifies an endpoint in the target API
public protocol Endpoint {
    
    /// Specifies type of input data
    typealias Input
    
    /// Specifies type of output data
    typealias Output
    
    /**
    * Initializes Endpoint with path
    * :param: path The path to the API
    */
    init(_ path: String)
    
    /// Contains HTTP Method such as GET, POST, etc.
    var method: Alamofire.Method { get }
    
    /// Contains path to the API
    var path: String { get }
}