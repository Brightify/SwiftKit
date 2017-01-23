//
//  ParametrizedInjectable.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 13/10/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

public protocol ParametrizedInjectable: Parametrizable {
    typealias InitParameters
    typealias Parameters = InitParameters
    
    init(injector: Injector, _ parameters: InitParameters)
}