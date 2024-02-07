//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    // MARK: UI Elements
    private let addClientButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("10명 추가", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("초기화", for: .normal)
        button.setTitleColor(.red, for: .normal)
        return button
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.setTitle("시작", for: .normal)
        button.setTitleColor(.systemBlue, for: .normal)
        return button
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(self.addClientButton)
        stackView.addArrangedSubview(self.clearButton)
        stackView.addArrangedSubview(self.startButton)
        return stackView
    }()
    
    private let timerView: TimerView = TimerView()
    
    private let waitingListTableView = ClientListTableView(type: .waiting)
    
    private let workingListTableView = ClientListTableView(type: .working)
    
    private lazy var listStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(self.waitingListTableView)
        stackView.addArrangedSubview(self.workingListTableView)
        return stackView
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        
        stackView.addArrangedSubview(self.buttonStackView)
        stackView.addArrangedSubview(self.timerView)
        stackView.addArrangedSubview(self.listStackView)
        
        return stackView
    }()
    
    private lazy var waitingListDataSource = ClientListDataSource(self.waitingListTableView)
    
    private lazy var workingListDataSource = ClientListDataSource(self.workingListTableView)
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayout()
        applyUpdatedWaitingList()
        applyUpdatedWorkingList()
        
        self.waitingListTableView.delegate = self
        self.workingListTableView.delegate = self
    }
}

private extension ViewController {
    func setLayout() {
        self.view.backgroundColor = .white
        self.view.addSubview(containerView)
        self.addClientButton.translatesAutoresizingMaskIntoConstraints = false
        self.clearButton.translatesAutoresizingMaskIntoConstraints = false
        self.startButton.translatesAutoresizingMaskIntoConstraints = false
        self.buttonStackView.translatesAutoresizingMaskIntoConstraints = false
        self.timerView.translatesAutoresizingMaskIntoConstraints = false
        self.waitingListTableView.translatesAutoresizingMaskIntoConstraints = false
        self.workingListTableView.translatesAutoresizingMaskIntoConstraints = false
        self.listStackView.translatesAutoresizingMaskIntoConstraints = false
        self.containerView.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.containerView.leadingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.leadingAnchor),
            self.containerView.trailingAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.trailingAnchor),
            self.containerView.topAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.topAnchor),
            self.containerView.bottomAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.bottomAnchor),
            
            self.buttonStackView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.05),
            self.timerView.heightAnchor.constraint(equalTo: self.view.safeAreaLayoutGuide.heightAnchor, multiplier: 0.1),
        ])
    }
    
    private func applyUpdatedWaitingList() {
        var snapshot = ClientListSnapShot()
        snapshot.appendSections([.client])
        let items = [
            Client(number: 1, task: .deposit),
            Client(number: 2, task: .loan),
        ].map(ClientListItem.client)
        snapshot.appendItems(items, toSection: .client)
        self.waitingListDataSource.apply(snapshot)
    }
    
    private func applyUpdatedWorkingList() {
        var snapshot = ClientListSnapShot()
        snapshot.appendSections([.client])
        let items = [
            Client(number: 1, task: .deposit),
            Client(number: 2, task: .loan),
        ].map(ClientListItem.client)
        snapshot.appendItems(items, toSection: .client)
        self.workingListDataSource.apply(snapshot)
    }
}

extension ViewController: UITableViewDelegate {
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        if let tableView = tableView as? ClientListTableView {
            return tableView.getHeader()
        }
        return nil
    }
}
