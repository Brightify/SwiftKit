//
//  InjectionError.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 13/10/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

class InjectionError<T>: ErrorType {
    let binding: Binding<T>?
    
    init(_ binding: Binding<T>?) {
        self.binding = binding
    }
    
    @noreturn
    func crash() {
        fatalError("Binding for type \(T.self) was \(binding)!")
    }
}