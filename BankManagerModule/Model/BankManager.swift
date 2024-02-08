//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

final class BankManager {
    weak var delegate: BankManagerDelegate?
    
    private let bankers: [Banker]
    
    private let clientManagers: [BankTask: ClientEnqueuable & ClientClearable]
    
    private var currentClientNumber: Int
    
    private var group: DispatchGroup?
    
    private var isWorking: Bool = false
    
    private lazy var timer = BankTimer(delegate: self)
    
    init(
        bankers: [Banker],
        clientManagers: [BankTask: ClientEnqueuable & ClientClearable]
    ) {
        self.bankers = bankers
        self.clientManagers = clientManagers
        self.currentClientNumber = 0
    }
    
    func start() {
        guard self.isWorking == false else { return }
        self.isWorking = true
        
        self.group = DispatchGroup()
        guard let group else { return }
        
        self.timer.start()
        DispatchQueue.global().async {
            for banker in self.bankers {
                banker.start(group: group)
            }
            group.wait()
            self.timer.end()
            self.resetClientCount()
            self.isWorking = false
        }
    }
    
    func clearBank() {
        guard self.isWorking else { return }
        self.timer.reset()
        for (_, clientManager) in self.clientManagers {
            clientManager.clearClients()
        }
        resetClientCount()
    }
    
    func addClients(count: Int) {
        let types = self.clientManagers.map { $0.key }
        for number in (currentClientNumber + 1)...(currentClientNumber + count) {
            guard let bankTaskType = types.randomElement() else { return }
            let client = Client(number: number, task: bankTaskType)
            self.clientManagers[bankTaskType]?.enqueueClient(client: client)
            self.currentClientNumber = number
        }
        
//        self.timer.start()
//        guard let group else { return }
//        self.bankers.forEach { banker in
//            banker.start(group: group)
//        }
        start()
    }
}

private extension BankManager {
    func measure(_ progress: () -> Void) -> TimeInterval {
        let start = Date()
        progress()
        return Date().timeIntervalSince(start)
    }
    
    func resetClientCount() {
        self.currentClientNumber = 0
    }
}

extension BankManager: ClientManagerDelegate {
    func handleEnqueueClient(client: Client) {
        self.delegate?.handleEnqueueClient(client: client)
    }
    
    func handleDequeueClient(client: Client) {
        self.delegate?.handleDequeueClient(client: client)
    }
    
    func handleClearClient() {
        self.delegate?.handleClearClient()
    }
}

extension BankManager: BankerDelegate {
    func handleStartTask(client: Client) {
        self.delegate?.handleStartTask(client: client)
    }
    
    func handleEndTask(client: Client) {
        self.delegate?.handleEndTask(client: client)
    }
}

extension BankManager: BankTimerDelegate {
    func handleUpdating(timeString: String) {
        self.delegate?.handleTimer(timeString: timeString)
    }
}

protocol BankManagerEnqueueClientDelegate: AnyObject {
    func handleEnqueueClient(client: Client)
}

protocol BankManagerDequeueClientDelegate: AnyObject {
    func handleDequeueClient(client: Client)
}

protocol BankManagerClearClientDelegate: AnyObject {
    func handleClearClient()
}

protocol BankManagerStartTaskDelegate: AnyObject {
    func handleStartTask(client: Client)
}

protocol BankManagerEndTaskDelegate: AnyObject {
    func handleEndTask(client: Client)
}

protocol BankManagerTimerDelegate: AnyObject {
    func handleTimer(timeString: String)
}

typealias BankManagerDelegate = BankManagerEnqueueClientDelegate & BankManagerDequeueClientDelegate & BankManagerClearClientDelegate & BankManagerStartTaskDelegate & BankManagerEndTaskDelegate & BankManagerTimerDelegate
