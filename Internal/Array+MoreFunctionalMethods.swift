internal extension Array {

    
    
    internal func arrayByAdding(elements: T...) -> Array<T> {
        return arrayByAdding(elements)
    }
    
    internal func arrayByAdding(elements: [T]) -> Array<T> {
        var mutableSelf = self
        elements.each(mutableSelf.append)
        return mutableSelf
    }
    
    internal func each(closure: (T) -> ()) -> Array<T> {
        return map {
            closure($0)
            return $0
        }
    }
    
    internal func product<U>(other: [U]) -> Array<(T, U)> {
        return flatMap { t in
            other.map { u in (t, u) }
        }
    }
}