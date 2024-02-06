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
    
    init?(inputHandler: TextInputReadable, outputHandler: TextOutputDisplayable) {
        self.input = inputHandler
        self.output = outputHandler
        self.mirror = Self.makeBankMirror()
    }
    
    func start() {
        while self.isRunning {
            startLoop()
        }
    }
}

private extension BankManagerApp {
    // swiftlint:disable function_body_length
    static func makeBankMirror() -> BankMirror {
        let orders = [
            Order(taskType: .loan, bankerCount: 1),
            Order(taskType: .deposit, bankerCount: 2),
        ]
        
        let console = ConsoleManager()
        var taskManagers = [BankTask: TaskManagable]()
        
        let bankManager = BankManager(textOut: console, taskManagers: taskManagers)
        
        for order in orders {
            let taskManager = TaskManager()
            taskManager.delegate = bankManager
            (1...order.bankerCount).forEach { _ in
                var banker = Banker(resultOut: console)
                banker.delegate = taskManager
                taskManager.enqueueBanker(banker)
            }
            taskManagers.updateValue(taskManager, forKey: order.taskType)
        }
        
        let mirror = BankMirror(bankManager: bankManager)
        bankManager.delegate = mirror
        return mirror
    }
    // swiftlint:enable function_body_length
    
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
        self.mirror.startBank()
    }
    
    func handle(error: Error) {
        self.output.display(output: error.localizedDescription)
    }
}

protocol BankInput {
    func startBank()
    func resetBank()
    func addClients(count: Int)
}

protocol BankOutput {
    func updateTimer()
    func didStartWorking(of client: Client)
    func didEndWorking(of client: Client)
}
