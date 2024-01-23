//
//  LinkedList.swift
//  BankManagerConsoleApp
//
//  Created by 강창현 on 1/23/24.
//

struct LinkedList<T> {
    
    // MARK: - Properties
    private var head: Node<T>?
    var first: T? {
        return head?.data
    }
    var isEmpty: Bool {
        return head == nil
    }
    
    init(head: Node<T>? = nil) {
        self.head = head
    }
    
    // MARK: - Methods
    mutating func append(data: T?) {
        if head == nil {
            head = Node(data: data)
        }
        var node = head
        while node?.next != nil {
            node = node?.next
        }
        node?.next = Node(data: data)
    }
    
    @discardableResult
    mutating func remove(at index: Int) -> T? {
        if head == nil { return nil }
        
        if index == 0 || head?.next == nil {
            let removedNode = head?.data
            head = head?.next
            return removedNode
        }
        var node = head
        for _ in 0..<(index - 1) {
            if node?.next?.next == nil { break }
            node = node?.next
        }
        let removedNode = node?.next?.data
        node?.next = node?.next?.next
        return removedNode
    }
    
    // MARK: - Private Methods
    mutating private func insert(data: T?, at index: Int) {
        if head == nil {
            head = Node(data: data)
        }
        var node = head
        for _ in 0..<(index - 1) {
            node = node?.next
        }
        let nextNode = node?.next
        node?.next = Node(data: data)
        node?.next?.next = nextNode
    }
}
