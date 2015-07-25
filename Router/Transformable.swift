//
//  Transformable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/25/15.
//
//

/**
    Classes conforming this protocol can decide how they get transformed to JSON.
*/
@availability(*, deprecated=0.4.3, message="This protocol and its support will be removed before 1.0.0 of SwiftKit. Please use Mappable instead.")
public protocol Transformable {
    
    /**
        Transforms JSON to object of type that implements Transformable
        
        :param: value The source JSON
        :returns: object of type that implements Transformable
    */
    static func transformFromJSON(value: AnyObject?) -> Self?
    
    /**
        Transforms an object that implements Transformable to JSON
        
        :param: value the object to be transformed
        :returns: The produced JSON
    */
    static func transformToJSON(value: Self?) -> AnyObject?
    
}