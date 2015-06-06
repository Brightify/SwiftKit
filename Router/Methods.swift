//
//  Methods.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

import Foundation
import Alamofire

public class Target<ENDPOINT: Endpoint, PARAMS> {
    private let path: (PARAMS) -> String
    
    public init(_ path: PARAMS -> String) {
        self.path = path
    }
    
    public func endpoint(params: PARAMS) -> ENDPOINT {
        return ENDPOINT(path(params))
    }
}

class BaseEndpoint<IN, OUT>: Endpoint {
    typealias Input = IN
    typealias Output = OUT
    
    let method: Alamofire.Method
    let path: String
    
    init(path: String, method: Alamofire.Method) {
        self.path = path
        self.method = method
    }
    
    required init(_ path: String) {
        fatalError("Initializer init(path:String) cannot be used in BaseEndpoint!")
    }
}

public class GET<IN, OUT>: BaseEndpoint<IN, OUT> {
    public required init(_ path: String) {
        super.init(path: path, method: .GET)
    }
}

public class POST<IN, OUT>: BaseEndpoint<IN, OUT> {
    public required init(_ path: String) {
        super.init(path: path, method: .POST)
    }
}

public class PUT<IN, OUT>: BaseEndpoint<IN, OUT> {
    public required init(_ path: String) {
        super.init(path: path, method: .PUT)
    }
}

public class DELETE<IN, OUT>: BaseEndpoint<IN, OUT> {
    public required init(_ path: String) {
        super.init(path: path, method: .DELETE)
    }
}

public class OPTIONS<IN, OUT>: BaseEndpoint<IN, OUT> {
    public required init(_ path: String) {
        super.init(path: path, method: .OPTIONS)
    }
}

public class HEAD<IN, OUT>: BaseEndpoint<IN, OUT> {
    public required init(_ path: String) {
        super.init(path: path, method: .HEAD)
    }
}

public class PATCH<IN, OUT>: BaseEndpoint<IN, OUT> {
    public required init(_ path: String) {
        super.init(path: path, method: .PATCH)
    }
}

public class TRACE<IN, OUT>: BaseEndpoint<IN, OUT> {
    public required init(_ path: String) {
        super.init(path: path, method: .TRACE)
    }
}

public class CONNECT<IN, OUT>: BaseEndpoint<IN, OUT> {
    public required init(_ path: String) {
        super.init(path: path, method: .CONNECT)
    }
}
