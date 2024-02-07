//
//  BankManager.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import Foundation

final class BankManager {
//    private let textOut: TextOutputDisplayable
    
    private var taskManagers: [BankTask: TaskManagable]
    
    weak var delegate: BankManagerDelegate?
    
    private var currentClientNumber: Int
    
    init(
//        textOut: TextOutputDisplayable,
        taskManagers: [BankTask: TaskManagable] = [:]
    ) {
//        self.textOut = textOut
        self.taskManagers = taskManagers
        self.currentClientNumber = 0
    }
}

extension BankManager: BankRunnable {
    func addClients(count: Int) {
        DispatchQueue.global().async {
            self.makeClients(count: count)
        }
    }
    
    func runBank() {
        DispatchQueue.global().async {
            let group = DispatchGroup()
            let totalWorkTime = self.measure {
                self.taskManagers.forEach { (_, taskManager) in
                    taskManager.startTaskManaging(group: group)
                }
                group.wait()
                self.resetClientCount()
            }
        }
    }
    
    func resetBank() {
        for (_, taskManager) in self.taskManagers {
            taskManager.resetTask()
        }
        resetClientCount()
    }
}

private extension BankManager {
    func makeClients(count: Int) {
        let types = self.taskManagers.map { $0.key }
        for number in (currentClientNumber + 1)...(currentClientNumber + count) {
            guard let type = types.randomElement() else {
                return
            }
            let client = Client(number: number, task: type)
            guard let taskManager = taskManagers[type] as? ClientEnqueuable else {
                return
            }
            taskManager.enqueueClient(client)
            self.currentClientNumber = number
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
//        self.textOut.display(output: output)
    }
    
    func resetClientCount() {
        self.currentClientNumber = 0
    }
}

extension BankManager: TaskManagerDequeueClientDelegate {
    func handleDequeueClient(client: Client) {
        self.delegate?.handleDequeueClient(client: client)
    }
}

extension BankManager: TaskManagerEnqueueClientDelegate {
    func handleEnqueueClient(newClient: Client) {
        self.delegate?.handleEnqueueClient(client: newClient)
    }
}

extension BankManager: TaskManagerDidEndTaskDelegate {
    func handleEndTask(client: Client) {
        self.delegate?.handleEndTask(client: client)
    }
}

extension BankManager: TaskManagerDidStartTaskDelegate {
    func handleStartTask(client: Client) {
        self.delegate?.handleStartTask(client: client)
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

// swiftlint:disable line_length
typealias BankManagerDelegate = BankManagerDequeueClientDelegate & BankManagerEnqueueClientDelegate & BankManagerEndTaskDelegate & BankManagerStartTaskDelegate
// swiftlint:enable line_length
