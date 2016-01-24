//
//  RequestPerformer.swift
//  Pods
//
//  Created by Tadeas Kriz on 28/07/15.
//
//

import Foundation
import SwiftKitStaging

public protocol RequestPerformer {
    
    func performRequest(request: Request, completion: Response<NSData?> -> ()) -> Cancellable
    
}