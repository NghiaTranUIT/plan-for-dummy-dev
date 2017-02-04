//: Playground - noun: a place where people can play

import UIKit

var str = "Hello, playground"

class LinkedListNode<T> {
    
    //
    // MARK: - Variable
    let data: T
    
    // Next
    var next: LinkedListNode?
    
    //
    // MARK: - Initial
    init(data: T) {
        self.data = data
    }
}

extension LinkedListNode: CustomStringConvertible {
    var description: String {
        return "\(self.data)"
    }
}

class LinkedList<T> {
    
    typealias Node = LinkedListNode<T>
    
    //
    // MARK: - Variable
    fileprivate var head: Node?
    
    //
    // MARK: - Helper
    var count: Int {
        var value = 0
        
        var lastNode = self.head
        while lastNode != nil {
            value = value + 1
            lastNode = lastNode!.next
        }
        
        return value
    }
    
    var first: Node? {
        return self.head
    }
    
    var last: Node? {
        guard let head = self.head else {return nil}
        
        var lastNode = head
        
        while lastNode.next != nil {
            lastNode = lastNode.next!
        }
        
        return lastNode
    }
    
    var isEmpty: Bool {
        return self.head == nil
    }
    
    //
    // MARK: - Action
    func append(_ value: T) {
        let node = LinkedListNode<T>(data: value)
        self.append(node)
    }
    
    func append(_ node: Node) {
        
        // As head
        if self.head == nil {
            self.head = node
            return
        }
        
        // Append
        guard let lastNode = self.last else {return}
        lastNode.next = node
    }
    
    func removeLast() -> Node? {
        guard let head = self.head else {
            return nil
        }
        
        var lastNode = head
        var previousNode: Node?
        while lastNode.next != nil {
            previousNode = lastNode
            lastNode = lastNode.next!
        }
        
        // remove
        // It means have only 1
        if previousNode == nil {
            self.head = nil
            return lastNode
        }
        
        guard let _previousNode = previousNode else {return nil}
        _previousNode.next = nil
        
        // Return
        return lastNode
    }
    
    func nodeAt(_ index: Int) -> Node? {
        
        guard index >= 0 else {return nil}
        
        var i = index + 1
        var lastNode = self.head
        while lastNode != nil {
            i = i - 1
            
            if i == 0 {
                return lastNode
            }
            
            // Next
            lastNode = lastNode!.next
        }
        
        return nil
    }
    
    subscript(index: Int) -> Node? {
        return self.nodeAt(index)
    }
    
    func map<U>(transform: (T) -> U) -> LinkedList<U> {
        
        // Transform
        let result = LinkedList<U>()
        
        var lastNode = self.head
        while lastNode != nil {
            
            // Transform
            let newData = transform(lastNode!.data)
            let newNode = LinkedListNode<U>(data: newData)
            
            // Add
            result.append(newNode)
            
            // Next
            lastNode = lastNode!.next
        }
        
        return result
    }
}

extension LinkedList: CustomStringConvertible {
    var description: String {
        var customeStr = ""
        
        for i in 0..<self.count {
            let node = self.nodeAt(i)
            customeStr = customeStr + "[\(node!)]"
        }
        
        return customeStr
    }
}

final class LinkedListIterator<T>: IteratorProtocol {
    
    typealias Element = LinkedListNode<T>
    
    fileprivate var list: LinkedList<T>?
    fileprivate var currentNode: Element?
    
    init(list: LinkedList<T>) {
        self.list = list
        self.currentNode = list.head
    }
    
    func next() -> Element? {
        if self.currentNode != nil {
            self.currentNode = self.currentNode?.next
        }
        return self.currentNode
    }
}

extension LinkedList: Sequence {
    
    typealias Iterator = LinkedListIterator<T>
    
    func makeIterator() -> Iterator {
        return LinkedListIterator<T>(list: self)
    }
}

// Testing
let linkedList = LinkedList<Int>()

linkedList.append(1)
linkedList.append(2)
linkedList.append(3)
linkedList.append(4)
linkedList.append(5)
linkedList.append(6)

// Count
print(linkedList.count)

// First
linkedList.first

// last
linkedList.last

// Index of
linkedList[2]

// Remove last
linkedList.removeLast()

// Append
linkedList.append(100)

// Map
let result = linkedList.map { (value) -> String in
    return "\(value)"
}

// Conform with Squence protocol from swift
// So we can iterator each element in LinkedList easily
for i in linkedList {
    print(i.data)
}
