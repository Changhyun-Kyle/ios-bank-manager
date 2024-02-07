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
    
    private let waitingQueueView = ListView(type: .waiting)
    
    private let workingQueueView = ListView(type: .working)
    
    private lazy var queueStackView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        
        stackView.addArrangedSubview(self.waitingQueueView)
        stackView.addArrangedSubview(self.workingQueueView)
        return stackView
    }()
    
    private lazy var containerView: UIStackView = {
        let stackView = UIStackView()
        stackView.axis = .vertical
        stackView.spacing = 0
        
        stackView.addArrangedSubview(self.buttonStackView)
        stackView.addArrangedSubview(self.timerView)
        stackView.addArrangedSubview(self.queueStackView)
        
        return stackView
    }()
    
    // MARK: Lifecycle Methods
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayout()
        
        self.waitingQueueView.addLabel(client: .init(number: 1, task: .deposit))
        self.waitingQueueView.addLabel(client: .init(number: 2, task: .loan))
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
        self.waitingQueueView.translatesAutoresizingMaskIntoConstraints = false
        self.workingQueueView.translatesAutoresizingMaskIntoConstraints = false
        self.queueStackView.translatesAutoresizingMaskIntoConstraints = false
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
}
