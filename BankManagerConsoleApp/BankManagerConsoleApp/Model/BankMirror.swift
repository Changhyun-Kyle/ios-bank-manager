//
//  BankMirror.swift
//  BankManagerConsoleApp
//
//  Created by Effie on 2/5/24.
//

import Foundation

final class BankMirror {
    private lazy var bankManager: BankRunnable? = nil
    
    private var waitingList: [Client]
    
    private var workingList: [Client]
    
    private var waitingSemaphore = DispatchSemaphore(value: 1)
    
    private var workingSemaphore = DispatchSemaphore(value: 1)
    
    init(
        waitingList: [Client] = [],
        workingList: [Client] = []
    ) {
        self.waitingList = waitingList
        self.workingList = workingList
        
        do {
            let console = ConsoleManager()
            let dispenser = try TicketDispenser(totalClientCount: 30)
            
            let manager = BankManager(
                textOut: console,
                dispenser: dispenser,
                delegate: self
            )
            self.bankManager = manager
        } catch {
            print(error)
        }
    }
}

extension BankMirror: BankManagerDequeueClientDelegate {
    func handleDequeueClient(client: Client) {
        removeWaitingClient(client: client)
    }
}

extension BankMirror: BankManagerEnqueueClientDelegate {
    func handleEnqueueClient(client: Client) {
        addWaitingClient(client: client)
    }
}

extension BankMirror: BankManagerEndTaskDelegate {
    func handleEndTask(client: Client) {
        removeWorkingClient(client: client)
    }
}

extension BankMirror: BankManagerStartTaskDelegate {
    func handleStartTask(client: Client) {
        addWorkingClient(client: client)
    }
}

private extension BankMirror {
    func addWaitingClient(client: Client) {
        self.waitingSemaphore.wait()
        self.waitingList.append(client)
        self.waitingSemaphore.signal()
    }
    
    func removeWaitingClient(client: Client) {
        self.waitingSemaphore.wait()
        guard
            let index = self.waitingList.firstIndex(where: { target in client == target })
        else { return }
        self.waitingList.remove(at: index)
        self.waitingSemaphore.signal()
    }
    
    func addWorkingClient(client: Client) {
        self.workingSemaphore.wait()
        self.workingList.append(client)
        self.workingSemaphore.signal()
    }
    
    func removeWorkingClient(client: Client) {
        self.workingSemaphore.wait()
        guard
            let index = self.workingList.firstIndex(where: { target in client == target })
        else { return }
        self.workingList.remove(at: index)
        self.workingSemaphore.signal()
    }
}

extension BankMirror: BankInput {
    func startBank(initialOrder: [Order], initialClientCount: Int) {
        self.bankManager?.runBank(with: initialOrder, numberOfClient: initialClientCount)
    }
    
    func resetBank() {
        
    }
    
    func addClients(count: Int) {
        
    }
}
