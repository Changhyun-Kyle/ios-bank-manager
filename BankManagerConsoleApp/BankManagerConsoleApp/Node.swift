//
//  Node.swift
//  BankManagerConsoleApp
//
//  Created by 강창현 on 1/23/24.
//

final class Node<T> {
    
    // MARK: - Propertise
    var data: T?
    var next: Node?
    
    // MARK: - Init
    init(data: T? = nil, next: Node? = nil) {
        self.data = data
        self.next = next
    }
}
