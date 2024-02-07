//
//  BankInput.swift
//  BankManagerConsoleApp
//
//  Created by Effie on 2/6/24.
//

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

protocol BankOutputable: AnyObject {
    func updateWaitingList(with clients: [Client])
    func updateWorkingList(with clients: [Client])
}
