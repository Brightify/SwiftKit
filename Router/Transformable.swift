//
//  Transformable.swift
//  Pods
//
//  Created by Tadeáš Kříž on 6/25/15.
//
//


/// Protocol used for transforming object to JSON and vice versa
public protocol Transformable {
    
    /**
    * Transforms JSON to object of type that implements Transformable
    * :param: value The source JSON
    * :returns: object of type that implements Transformable
    */
    static func transformFromJSON(value: AnyObject?) -> Self?
    
    /**
    * Transforms an object that implements Transformable to JSON
    * :param: value the object to be transformed
    * :returns: The produced JSON
    */
    static func transformToJSON(value: Self?) -> AnyObject?
    
}