//
//  LinkedList.swift
//  BankManagerConsoleApp
//
//  Created by 강창현 on 1/23/24.
//

struct LinkedList<Value> {
    private(set) var head: Node<Value>?
    
    private(set) var tail: Node<Value>?

    var first: Value? {
        return head?.value
    }
    
    var isEmpty: Bool {
        return head == nil
    }
    
    init(head: Node<Value>? = nil) {
        self.head = head
    }
    
    mutating func add(value: Value) {
        let newNode = Node(value: value)
        guard let currentTail = self.tail else {
            self.head = newNode
            self.tail = self.head
            return
        }
        let previousTail = self.tail
        previousTail?.next = newNode
        self.tail = self.tail?.next
    }
    
    @discardableResult
    mutating func removeFirst() -> Value? {
        let result = head?.value
        self.head = head?.next
        return result
    }
}
