/*
  Last-in first-out stack (LIFO)

  Push and pop are O(1) operations.
*/
public struct Stack<T> {
  private var array = [T]()

  public var isEmpty: Bool {
    return array.isEmpty
  }

  public var count: Int {
    return array.count
  }

  public mutating func push(_ element: T) {
    array.append(element)
  }

  public mutating func pop() -> T? {
    if isEmpty {
      return nil
    } else {
      return array.removeLast()
    }
  }

  public func peek() -> T? {
    return array.last
  }
}

extension Stack: Sequence {
    public func makeIterator() -> AnyIterator<T> {
        var curr = self
        return AnyIterator {
            _ -> T? in
            return curr.pop()
        }
    }
}
