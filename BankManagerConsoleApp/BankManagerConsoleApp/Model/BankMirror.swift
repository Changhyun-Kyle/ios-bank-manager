//
//  BankMirror.swift
//  BankManagerConsoleApp
//
//  Created by Effie on 2/5/24.
//

final class BankMirror {
    private lazy var bankManager: BankRunnable? = nil
    
    private var list: [Client]
    
    private var workingList: [Client]
    
    init(
        list: [Client] = [],
        workingList: [Client] = []
    ) {
        self.list = list
        self.workingList = workingList
        
        do {
            #warning("야야 바꿔라")
            let console = ConsoleManager()
            let dispenser = try TicketDispenser(totalClientCount: 30)
            
            let manager = BankManager(textOut: console, dispenser: dispenser)
            manager.delegate = self
            self.bankManager = manager
        } catch {
            print(error)
        }
    }
}

extension BankMirror: BankManagerDequeueDelegate {
    func handleDequeue(client: Client) {
        removeWaitingClient(client: client)
        addWorkingClient(client: client)
    }
}

extension BankMirror: BankManagerEnqueueDelegate {
    func handleEnqueue(client: Client) {
        addWaitingClient(client: client)
    }
}

extension BankMirror: BankManagerDequeueWorkingClient {
    func handleDequeueWorkingClient(client: Client) {
        removeWorkingClient(client: client)
    }
}

private extension BankMirror {
    func removeWaitingClient(client: Client) {
        guard
            let index = self.list.firstIndex(where: { target in client == target })
        else { return }
        self.list.remove(at: index)
    }
    
    func addWorkingClient(client: Client) {
        self.workingList.append(client)
    }
    
    func addWaitingClient(client: Client) {
        // race...
        self.list.append(client)
    }
    
    func removeWorkingClient(client: Client) {
        guard
            let index = self.workingList.firstIndex(where: { target in client == target })
        else { return }
        self.workingList.remove(at: index)
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
