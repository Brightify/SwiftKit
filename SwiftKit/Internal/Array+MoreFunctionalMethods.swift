internal extension Array {

    internal func arrayByAppending(elements: Element...) -> Array<Element> {
        return arrayByAppending(elements)
    }
    
    internal func arrayByAppending(elements: [Element]) -> Array<Element> {
        var mutableCopy = self
        mutableCopy.appendContentsOf(elements)
        return mutableCopy
    }
    
    internal func product<U>(other: [U]) -> Array<(Element, U)> {
        return flatMap { t in
            other.map { u in (t, u) }
        }
    }
}