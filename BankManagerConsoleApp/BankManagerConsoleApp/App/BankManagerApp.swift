//
//  BankManagerApp.swift
//  BankManagerConsoleApp
//
//  Created by Effie on 2/1/24.
//

final class BankManagerApp {
    private let input: TextInputReadable
    
    private let output: TextOutputDisplayable
    
    private let mirror: BankMirror
    
    private var isRunning: Bool = true
    
    init(inputHandler: TextInputReadable, outputHandler: TextOutputDisplayable) {
        self.input = inputHandler
        self.output = outputHandler
        self.mirror = BankMirror()
    }
    
    func start() {
        while self.isRunning {
            startLoop()
        }
    }
}

private extension BankManagerApp {
    func startLoop() {
        self.output.display(output: BankManagerAppMenu.allMenusPrompt)
        do {
            let input = try self.input.readInput(prompt: "입력:")
            let menu = try BankManagerAppMenu(input: input)
            handle(menu: menu)
        } catch {
            handle(error: error)
        }
    }
    
    func handle(menu: BankManagerAppMenu) {
        switch menu {
        case .open:
            do {
                try startBank()
            } catch {
                handle(error: error)
            }
        case .end:
            self.isRunning = false
        }
    }
    
    func startBank() throws {
        guard let clientCount = (10...30).randomElement() else { throw BankManagerAppError.outOfIndex }
        let dispenser = try TicketDispenser(totalClientCount: clientCount)
        let orders = [
            Order(taskType: .loan, bankerCount: 1),
            Order(taskType: .deposit, bankerCount: 2),
        ]
        self.mirror.startBank(initialOrder: orders, initialClientCount: clientCount)
        
    }
    
    func handle(error: Error) {
        self.output.display(output: error.localizedDescription)
    }
}

protocol BankInput {
    func startBank(initialOrder: [Order], initialClientCount: Int)
    func resetBank()
    func addClients(count: Int)
}

protocol BankOutput {
    func updateTimer()
    func didStartWorking(of client: Client)
    func didEndWorking(of client: Client)
}
