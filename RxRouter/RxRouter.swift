//
//  RxRouter.swift
//  SwiftKit
//
//  Created by Filip Dolnik on 09.12.16.
//  Copyright © 2016 Brightify. All rights reserved.
//

import RxSwift
import Result

public struct RxRouter {
    
    public let router: Router
    
    public init(router: Router) {
        self.router = router
    }

    public func observe<T>(request: @escaping (@escaping (Response<T>) -> Void) -> Cancellable) -> Observable<Response<T>> {
        return Observable<Response<T>>.create { observer in
            let cancellable = request { response in
                observer.onNext(response)
            }
            return Disposables.create {
                cancellable.cancel()
            }
        }
    }
}
