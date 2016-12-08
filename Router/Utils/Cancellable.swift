//
//  Cancellable.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 24/01/16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import Foundation

/// Can be used to cancel requests.
public final class Cancellable {
    
    private static let syncQueue = DispatchQueue(label: "Cancellable_syncQueue")
    
    private var cancelAction: () -> Void
    private var shouldCancel = false
    
    public init(cancelAction: @escaping () -> Void = {}) {
        self.cancelAction = cancelAction
    }
    
    public func cancel() {
        Cancellable.syncQueue.sync {
            shouldCancel = true
            cancelAction()
        }
    }
    
    public func rewrite(with cancellable: Cancellable) {
        Cancellable.syncQueue.sync {
            shouldCancel = shouldCancel || cancellable.shouldCancel
            cancelAction = cancellable.cancelAction
            if (shouldCancel) {
                cancelAction()
            }
        }
    }
}
