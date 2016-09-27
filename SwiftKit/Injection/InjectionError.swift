//
//  InjectionError.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 13/10/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

class InjectionError<T>: Error {
    let binding: Binding<T>?
    
    init(_ binding: Binding<T>?) {
        self.binding = binding
    }
    
    
    func crash() -> Never  {
        fatalError("Binding for type \(T.self) was \(binding)!")
    }
}
