//
//  Promise.swift
//  SwiftKit
//
//  Created by Tadeas Kriz on 16/09/15.
//  Copyright © 2015 Tadeas Kriz. All rights reserved.
//

private enum ValueOrError<T> {
    case Undetermined
    case Value(T)
    case Error(ErrorType)
}

public class Promise<IN, OUT> {
    private let dispatchGroup: dispatch_group_t
    private let action: () throws -> OUT
    private var output: ValueOrError<OUT> = .Undetermined
    
    convenience init(input: IN, action: IN throws -> OUT) {
        self.init {
            try action(input)
        }
    }
    
    init(action: Void throws -> OUT) {
        self.action = action
        dispatchGroup = dispatch_group_create()
        
        dispatch_group_async(dispatchGroup, dispatch_get_global_queue(DISPATCH_QUEUE_PRIORITY_HIGH, 0)) {
            do {
                let output = try self.action()
                self.output = .Value(output)
            } catch {
                self.output = .Error(error)
            }
        }
    }
    
    public func then<OUT2>(action: OUT throws -> OUT2) -> Promise<IN, OUT2> {
        return Promise<IN, OUT2> {
            try action(self.await())
        }
    }
    
    public func then<OUT2>(promise: Promise<OUT, OUT2>) -> Promise<IN, OUT2> {
        return Promise<IN, OUT2> {
            try promise.await()
        }
    }
    
    public func and<U>(action: () throws -> U) -> Promise<IN, (OUT, U)> {
        return Promise<IN, (OUT, U)> {
            let t = try self.await()
            let u = try action()
            return (t, u)
        }
    }
    
    public func onError(action: (ErrorType) -> ()) -> Promise<IN, OUT> {
        return Promise {
            do {
                return try self.await()
            } catch {
                action(error)
                throw error
            }
        }
    }
    
    @warn_unused_result
    public func await(timeout: dispatch_time_t = DISPATCH_TIME_FOREVER) throws -> OUT {
        switch(output) {
        case .Undetermined:
            dispatch_group_wait(dispatchGroup, timeout)
            return try await()
        case .Value(let value):
            return value
        case .Error(let error):
            throw error
        }
    }
}

infix operator |> { associativity left }

public func |> <IN, MID, OUT>(lhs: Promise<IN, MID>, rhs: Promise<MID, OUT>) -> Promise<IN, OUT> {
    return lhs.then(rhs)
}

public func |> <MID, OUT>(lhs: Void throws -> MID, rhs: MID throws -> OUT) -> Promise<Void, OUT> {
    return Promise(action: lhs).then(rhs)
}

public func |> <IN, MID, OUT>(lhs: Promise<IN, MID>, rhs: MID throws -> OUT) -> Promise<IN, OUT> {
    return lhs.then(rhs)
}

public func promise<OUT>(action: Void throws -> OUT) -> Promise<Void, OUT> {
    return Promise(action: action)
}

public func promise<IN, OUT>(input: IN, action: IN throws -> OUT) -> Promise<IN, OUT> {
    return Promise {
        try action(input)
    }
}