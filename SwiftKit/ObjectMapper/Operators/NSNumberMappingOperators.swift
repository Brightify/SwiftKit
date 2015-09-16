//
//  ObjectMapperOperators.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/25/15.
//
//

infix operator <- {}

private let nsnumberTransformation = NSNumberTransformation()

public func <- (inout field: NSNumber, map: Map) {
    field <- (map, nsnumberTransformation)
}

public func <- (inout field: NSNumber?, map: Map) {
    field <- (map, nsnumberTransformation)
}

public func <- (inout field: NSNumber!, map: Map) {
    field <- (map, nsnumberTransformation)
}

public func <- (inout field: [NSNumber], map: Map) {
    field <- (map, nsnumberTransformation)
}

public func <- (inout field: [NSNumber]!, map: Map) {
    field <- (map, nsnumberTransformation)
}

public func <- (inout field: [NSNumber]?, map: Map) {
    field <- (map, nsnumberTransformation)
}

public func <- (inout field: [String: NSNumber], map: Map) {
    field <- (map, nsnumberTransformation)
}

public func <- (inout field: [String: NSNumber]!, map: Map) {
    field <- (map, nsnumberTransformation)
}

public func <- (inout field: [String: NSNumber]?, map: Map) {
    field <- (map, nsnumberTransformation)
}