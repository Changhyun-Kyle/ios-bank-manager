//
//  Banker.swift
//  BankManagerConsoleApp
//
//  Created by Effie on 1/31/24.
//

import Foundation

struct Banker {
//    private let resultOut: TextOutputDisplayable
    
    weak var delegate: BankerDelegate?
    
    init(/*resultOut: TextOutputDisplayable*/) {
//        self.resultOut = resultOut
    }
}

extension Banker: ClientTaskHandlable {
    func handle(client: Client, group: DispatchGroup) {
        DispatchQueue.global().async(group: group) {
            startWork(client: client)
            processTask(for: client.task.duration)
            endWork(client: client)
        }
    }
}

private extension Banker {
    func startWork(client: Client) {
        self.delegate?.handleStartWorking(client: client)
//        resultOut.display(output: "\(client.number)번 고객 \(client.task.name) 시작")
    }
    
    func processTask(for duration: TimeInterval) {
        Thread.sleep(forTimeInterval: duration)
    }
    
    func endWork(client: Client) {
//        resultOut.display(output: "\(client.number)번 고객 \(client.task.name) 종료")
        self.delegate?.handleEndWorking(client: client, banker: self)
    }
}

protocol BankerStartWorkingDelegate: AnyObject {
    func handleStartWorking(client: Client)
}

protocol BankerEndWorkingDelegate: AnyObject {
    func handleEndWorking(client: Client, banker: ClientTaskHandlable)
}

typealias BankerDelegate = BankerStartWorkingDelegate & BankerEndWorkingDelegate
