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
    
    private let bankerSemaphore: DispatchSemaphore = .init(value: 1)
    
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
        DispatchQueue.global().async(group: group) {
            guard self.bankerQueue.isEmpty == false else {
                return
            }
            while self.clientQueue.isEmpty == false {
                guard
                    let banker = self.dequeueBanker(),
                    let client = self.dequeueClient()
                else {
                    continue
                }
                banker.handle(client: client, group: group)
            }
        }
    }
    
    func resetTask() {
        self.clientQueue.clear()
    }
}

extension TaskManager: BankerEnqueuable {
    func enqueueBanker(_ taskHandlable: ClientTaskHandlable) {
        self.bankerSemaphore.wait()
        self.bankerQueue.enqueue(taskHandlable)
        self.bankerSemaphore.signal()
    }
}

extension TaskManager: ClientEnqueuable {
    func enqueueClient(_ client: Client) {
        self.clientSemaphore.wait()
        self.clientQueue.enqueue(client)
        self.delegate?.handleEnqueueClient(newClient: client)
        self.clientSemaphore.signal()
    }
}

extension TaskManager: BankerStartWorkingDelegate {
    func handleStartWorking(client: Client) {
        self.delegate?.handleStartTask(client: client)
    }
}

extension TaskManager: BankerEndWorkingDelegate {
    func handleEndWorking(client: Client, banker: ClientTaskHandlable) {
        self.delegate?.handleEndTask(client: client)
        self.enqueueBanker(banker)
    }
}

private extension TaskManager {
    func dequeueBanker() -> ClientTaskHandlable? {
        self.bankerSemaphore.wait()
        let result = self.bankerQueue.dequeue()
        self.bankerSemaphore.signal()
        return result
    }
    
    func dequeueClient() -> Client? {
        self.clientSemaphore.wait()
        guard let client = self.clientQueue.dequeue() else {
            self.clientSemaphore.signal()
            return nil
        }
        self.delegate?.handleDequeueClient(client: client)
        self.clientSemaphore.signal()
        return client
    }
}

protocol TaskManagerEnqueueClientDelegate: AnyObject {
    func handleEnqueueClient(newClient: Client)
}

protocol TaskManagerDequeueClientDelegate: AnyObject {
    func handleDequeueClient(client: Client)
}

protocol TaskManagerDidStartTaskDelegate: AnyObject {
    func handleStartTask(client: Client)
}

protocol TaskManagerDidEndTaskDelegate: AnyObject {
    func handleEndTask(client: Client)
}

// swiftlint:disable line_length
typealias TaskManagerDelegate = TaskManagerEnqueueClientDelegate & TaskManagerDequeueClientDelegate & TaskManagerDidEndTaskDelegate & TaskManagerDidStartTaskDelegate
// swiftlint:enable line_length
