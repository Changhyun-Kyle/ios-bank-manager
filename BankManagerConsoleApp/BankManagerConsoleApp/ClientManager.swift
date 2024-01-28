//
//  ClientManager.swift
//  BankManagerConsoleApp
//
//  Created by Effie on 1/26/24.
//

import Foundation

final class ClientManager {
    private let clientQueue: Queue<Client>
    
//    private let semaphore: DispatchSemaphore = .init(value: 1)
    
    private var isLocked = false
    
    init() {
        self.clientQueue = Queue()
    }
}

extension ClientManager: ClientEnqueuable {
    func enqueueClient(_ client: Client) {
        self.clientQueue.enqueue(client)
    }
}

extension ClientManager: ClientDequeuable {
    func dispatchClient() -> Client? {
        lock()
        let result = self.clientQueue.dequeue()
        unlock()
        return result
    }
    
    private func lock() {
        self.isLocked = true
    }
    
    private func unlock() {
        self.isLocked = false
    }
}
