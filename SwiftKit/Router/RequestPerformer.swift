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
    
    func perform(request: Request, completion: @escaping (Response<Data?>) -> ()) -> Cancellable
    
}
