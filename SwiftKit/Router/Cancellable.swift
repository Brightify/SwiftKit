//
//  Cancellable.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 24/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

/// Can be used to cancel requests.
public struct Cancellable {
    
    private let cancelAction: () -> Void
    
    public init(cancelAction: @escaping () -> Void) {
        self.cancelAction = cancelAction
    }
    
    public func cancel() {
        cancelAction()
    }
}
