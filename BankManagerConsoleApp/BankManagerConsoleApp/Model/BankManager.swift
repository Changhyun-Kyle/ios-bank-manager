//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

final class BankManager {
    private let textOut: TextOutputDisplayable
    
    private let dispenser: TicketDispenser
    
    private let delegate: BankManagerDelegate
    
    init(
        textOut: TextOutputDisplayable,
        dispenser: TicketDispenser,
        delegate: BankManagerDelegate
    ) {
        self.textOut = textOut
        self.dispenser = dispenser
        self.delegate = delegate
    }
}

extension BankManager: BankRunnable {
    func runBank(with orders: [Order], numberOfClient: Int) {
        let group = DispatchGroup()
        let totalWorkTime = measure {
            for order in orders {
                let taskManager = TaskManager()
                taskManager.delegate = self
                makeClients(order: order, taskManager: taskManager)
                makeBankers(order: order, taskManager: taskManager)
                taskManager.startTaskManaging(group: group)
            }
            group.wait()
        }
        
        summarizeDailyStatistics(
            totalWorkTime: totalWorkTime,
            numberOfClient: numberOfClient
        )
    }
}

private extension BankManager {
    func makeBankers(order: Order, taskManager: TaskManager) {
        (1...order.bankerCount).forEach { _ in
            let banker = Banker(
                delegate: taskManager,
                resultOut: self.textOut
            )
            taskManager.enqueueBanker(banker)
        }
    }
    
    func makeClients(order: Order, taskManager: TaskManager) {
        while let number = self.dispenser.provideTicket(of: order.taskType) {
            let client = Client(number: number, task: order.taskType)
            taskManager.enqueueClient(client)
        }
    }
    
    func measure(_ progress: () -> Void) -> TimeInterval {
        let start = Date()
        progress()
        return Date().timeIntervalSince(start)
    }
    
    func summarizeDailyStatistics(totalWorkTime: Double, numberOfClient: Int) {
        let roundedWorkTimeString = String(format: "%.2f", totalWorkTime)
        let output = "업무가 마감되었습니다. 오늘 업무를 처리한 고객은 총 \(numberOfClient)명이며, 총 업무시간은 \(roundedWorkTimeString)초입니다."
        self.textOut.display(output: output)
    }
}

extension BankManager: TaskManagerDequeueClientDelegate {
    func handleDequeueClient(client: Client) {
        self.delegate.handleDequeueClient(client: client)
    }
}

extension BankManager: TaskManagerEnqueueClientDelegate {
    func handleEnqueueClient(newClient: Client) {
        self.delegate.handleEnqueueClient(client: newClient)
    }
}

extension BankManager: TaskManagerDidEndTaskDelegate {
    func handleEndTask(client: Client) {
        self.delegate.handleEndTask(client: client)
    }
}

extension BankManager: TaskManagerDidStartTaskDelegate {
    func handleStartTask(client: Client) {
        self.delegate.handleStartTask(client: client)
    }
}

protocol BankManagerDequeueClientDelegate: AnyObject {
    func handleDequeueClient(client: Client)
}

protocol BankManagerEnqueueClientDelegate: AnyObject {
    func handleEnqueueClient(client: Client)
}

protocol BankManagerEndTaskDelegate: AnyObject {
    func handleEndTask(client: Client)
}

protocol BankManagerStartTaskDelegate: AnyObject {
    func handleStartTask(client: Client)
}

typealias BankManagerDelegate = BankManagerDequeueClientDelegate & BankManagerEnqueueClientDelegate & BankManagerEndTaskDelegate & BankManagerStartTaskDelegate
