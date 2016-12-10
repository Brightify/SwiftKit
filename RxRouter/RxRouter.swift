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

    public func observe<T>(request: (@escaping (Response<T>) -> Void) -> Cancellable) -> Observable<Response<T>> {
        let subject = ReplaySubject<Response<T>>.create(bufferSize: 1)
        let cancellable = request { response in
            subject.onNext(response)
        }
        return add(cancellable: cancellable, to: subject)
    }
    
    public func observe<T>(request: (@escaping (Response<T>) -> Void) -> Cancellable) -> Observable<RouterResult<T>> {
        return observe(request: request).map { (response: Response<T>) in
            if let error = response.error {
                return .failure(.requestError(error, response.demap()))
            } else if response.statusCode?.isSuccess == false {
                return .failure(.invalidStatusCode(response.demap()))
            } else {
                return .success(response.output)
            }
        }
    }
    
    public func observe<T>(request: (@escaping (Response<T?>) -> Void) -> Cancellable) -> Observable<RouterResult<T>> {
        return observe(request: request).map { (result: RouterResult<T?>) in
            switch result {
            case .success(let maybeValue):
                if let value = maybeValue {
                    return .success(value)
                } else {
                    return .failure(.unknownError)
                }
            case .failure(let error):
                return .failure(error)
            }
        }
    }
    
    // TODO ?
    private func add<T>(cancellable: Cancellable, to observable: Observable<T>) -> Observable<T> {
        return observable.flatMap { value in
            Observable.create { observer in
                observer.onNext(value)
                return Disposables.create {
                    cancellable.cancel()
                }
            }
        }
    }
}
