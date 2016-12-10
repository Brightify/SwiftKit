//
//  Router+RxRouter.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 09.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

extension Router {
    
    public var rx: RxRouter {
        return RxRouter(router: self)
    }
}
