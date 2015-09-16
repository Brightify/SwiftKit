internal extension Array {

    internal func arrayByAdding(elements: Element...) -> Array<Element> {
        return arrayByAdding(elements)
    }
    
    internal func arrayByAdding(elements: [Element]) -> Array<Element> {
        var mutableSelf = self
        mutableSelf.appendContentsOf(elements)
        return mutableSelf
    }
    
    internal func product<U>(other: [U]) -> Array<(Element, U)> {
        return flatMap { t in
            other.map { u in (t, u) }
        }
    }
}