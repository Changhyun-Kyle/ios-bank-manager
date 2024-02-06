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
        
        let console = ConsoleManager()
//            guard let clientCount = (10...30).randomElement() else { throw BankManagerAppError.outOfIndex }
        
        let orders = [
            Order(taskType: .loan, bankerCount: 1),
            Order(taskType: .deposit, bankerCount: 2),
        ]
        
        var taskManagers = [BankTask: TaskManagable]()
        
        for order in orders {
            let taskManager = TaskManager()
            // TODO: TaskManager Delegate 설정
//                taskManager.delegate = self
            
            (1...order.bankerCount).forEach { _ in
                let banker = Banker(
                    delegate: taskManager,
                    resultOut: console
                )
                taskManager.enqueueBanker(banker)
            }
            
            taskManagers.updateValue(taskManager, forKey: order.taskType)
        }
        
        let manager = BankManager(
            textOut: console,
            taskManagers: taskManagers
        )
        
        self.mirror = BankMirror(bankManager: manager)
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
