//
//  TaskManager.swift
//  BankManagerConsoleApp
//
//  Created by Effie on 1/31/24.
//

import Foundation

final class TaskManager {
    private let clientQueue: Queue<Client>
    
    private let bankerQueue: Queue<ClientTaskHandlable>
    
    private let semaphore: DispatchSemaphore = .init(value: 1)
    
    private let clientSemaphore: DispatchSemaphore = .init(value: 1)
    
    weak var delegate: TaskManagerDelegate?
    
    init(
        clientQueue: Queue<Client> = .init(),
        bankerQueue: Queue<ClientTaskHandlable> = .init()
    ) {
        self.clientQueue = clientQueue
        self.bankerQueue = bankerQueue
    }
}

extension TaskManager: TaskManagable {
    func startTaskManaging(group: DispatchGroup) {
        let bankerCount = self.bankerQueue.count
        
        DispatchQueue.global().async(group: group) {
            while self.clientQueue.isEmpty == false {
                guard
                    let banker = self.dequeueBanker(),
                    let client = self.clientQueue.dequeue()
                else {
                    continue
                }
                // 시작했어!
                self.delegate?.handleDequeueClient(client: client)
                banker.handle(client: client, group: group)
                
                guard
                    self.bankerQueue.count != bankerCount
                else {
                    break
                }
            }
        }
    }
}

extension TaskManager: BankerEnqueuable {
    func enqueueBanker(_ taskHandlable: ClientTaskHandlable) {
        self.semaphore.wait()
        self.bankerQueue.enqueue(taskHandlable)
        self.semaphore.signal()
    }
}

extension TaskManager: ClientEnqueuable {
    func enqueueClient(_ client: Client) {
        self.clientSemaphore.wait()
        self.clientQueue.enqueue(client)
        self.delegate?.handleEnqueue(newClient: client)
        self.clientSemaphore.signal()
    }
}

extension TaskManager: BankerStartWorkingDelegate {
    func handleStartWorking(client: Client) {
        
    }
}

extension TaskManager: BankerEndWorkingDelegate {
    func handleEndWorking(client: Client) {
        
    }
}

extension TaskManager {
    private func dequeueBanker() -> ClientTaskHandlable? {
        self.semaphore.wait()
        let result = self.bankerQueue.dequeue()
        self.semaphore.signal()
        return result
    }
}

protocol TaskManagerEnqueueDelegate: AnyObject {
    func handleEnqueue(newClient: Client)
}

protocol TaskManagerDequeueClientDelegate: AnyObject {
    func handleDequeueClient(client: Client)
}

protocol TaskManagerDequeueWorkingClient: AnyObject {
    func handleDequeueWorkingClient(client: Client)
}

typealias TaskManagerDelegate = TaskManagerEnqueueDelegate & TaskManagerDequeueClientDelegate & TaskManagerDequeueWorkingClient
