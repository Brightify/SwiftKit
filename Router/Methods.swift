//
//  Methods.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/6/15.
//
//

import Foundation
import Alamofire

public class BaseEndpoint<IN, OUT>: Endpoint {
    typealias Input = IN
    typealias Output = OUT
    
    public let path: String
    public let method: Alamofire.Method
    
    init(path: String, method: Alamofire.Method) {
        self.path = path
        self.method = method
    }
    
}

public class GET<IN, OUT>: BaseEndpoint<IN, OUT> {
    public init(_ path: String) {
        super.init(path: path, method: .GET)
    }
}

public class POST<IN, OUT>: BaseEndpoint<IN, OUT> {
    public init(_ path: String) {
        super.init(path: path, method: .POST)
    }
}

public class PUT<IN, OUT>: BaseEndpoint<IN, OUT> {
    public init(_ path: String) {
        super.init(path: path, method: .PUT)
    }
}

public class DELETE<IN, OUT>: BaseEndpoint<IN, OUT> {
    public init(_ path: String) {
        super.init(path: path, method: .DELETE)
    }
}

public class OPTIONS<IN, OUT>: BaseEndpoint<IN, OUT> {
    public init(_ path: String) {
        super.init(path: path, method: .OPTIONS)
    }
}

public class HEAD<IN, OUT>: BaseEndpoint<IN, OUT> {
    public init(_ path: String) {
        super.init(path: path, method: .HEAD)
    }
}

public class PATCH<IN, OUT>: BaseEndpoint<IN, OUT> {
    public init(_ path: String) {
        super.init(path: path, method: .PATCH)
    }
}

public class TRACE<IN, OUT>: BaseEndpoint<IN, OUT> {
    public init(_ path: String) {
        super.init(path: path, method: .TRACE)
    }
}

public class CONNECT<IN, OUT>: BaseEndpoint<IN, OUT> {
    public init(_ path: String) {
        super.init(path: path, method: .CONNECT)
    }
}
