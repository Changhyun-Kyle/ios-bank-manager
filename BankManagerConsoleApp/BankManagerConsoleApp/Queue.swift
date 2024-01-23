//
//  Queue.swift
//  BankManagerConsoleApp
//
//  Created by 강창현 on 1/23/24.
//

struct Queue<T> {
    
    // MARK: - Properties
    private var linkedList = LinkedList<T>()
    
    var peek: T? {
        return linkedList.first
    }
    var isEmpty: Bool {
        return linkedList.isEmpty
    }
    
    init(linkedList: LinkedList<T> = LinkedList<T>()) {
        self.linkedList = linkedList
    }
    
    // MARK: - Methods
    mutating func enqueue(_ element: T) {
        linkedList.append(data: element)
    }
    
    mutating func dequeue() -> T? {
        guard !linkedList.isEmpty else { return nil }
        return linkedList.remove(at: 0)
    }
    
    mutating func clear() {
        while !linkedList.isEmpty {
            linkedList.remove(at: 0)
        }
    }
}
