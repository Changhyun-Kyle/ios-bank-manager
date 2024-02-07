//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import UIKit

enum BMColor {
    static let purple = UIColor(named: "BMPurple")
    static let green = UIColor(named: "BMGreen")
}

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

enum BankList {
    case waiting
    case working
    
    var backgroundColor: UIColor? {
        switch self {
        case .waiting: return BMColor.green
        case .working: return BMColor.purple
        }
    }
    
    var name: String {
        switch self {
        case .waiting: return "대기중"
        case .working: return "작업중"
        }
    }
}

final class TimerView: UIView {
    private let timerLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.text = "업무시간 - \("00:00:000")"
        label.textAlignment = .center
        label.font = .preferredFont(forTextStyle: .title2)
        return label
    }()
    
    init() {
        super.init(frame: .zero)
        setLayout()
    }
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    private func setLayout() {
        self.addSubview(timerLabel)
        self.timerLabel.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            self.timerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.timerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: -10),
            self.timerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.timerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: -10),
        ])
    }
}

final class ListView: UIView {
    typealias Label = ListLabel
    
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .largeTitle)
        label.textAlignment = .center
        label.textColor = .white
        return label
    }()
    
    private let list: ListStackView = ListStackView()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: BankList) {
        super.init(frame: .zero)
        self.titleLabel.text = type.name
        self.titleLabel.backgroundColor = type.backgroundColor
        setLayout()
    }
    
    private func setLayout() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.list)
        
        self.titleLabel.translatesAutoresizingMaskIntoConstraints = false
        self.list.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.list.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.list.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.list.widthAnchor.constraint(equalTo: self.widthAnchor),
            self.list.bottomAnchor.constraint(lessThanOrEqualTo: self.bottomAnchor),
        ])
        
        let listViewHeight = self.list.heightAnchor.constraint(equalToConstant: 1)
        listViewHeight.priority = .defaultLow
        listViewHeight.isActive = true
    }
    
    func addLabel(client: Client) {
        let label = Label(client: client)
        self.list.addArrangedSubview(label)
    }
}

final class ListStackView: UIStackView {
    //    func reload(list: [Client]) {
    //        for subview in self.arrangedSubviews {
    //            subview.removeFromSuperview()
    //        }
    //
    //        for client in list {
    //            let label = ListLabel()
    //            label.configure(client: client)
    //            self.addArrangedSubview(label)
    //        }
    //    }
    
    @available(*, unavailable)
    required init(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init() {
        super.init(frame: .zero)
        self.axis = .vertical
        self.spacing = 10
        self.alignment = .center
    }
    
    func removeLabel(index: Int) {
        guard index < self.arrangedSubviews.count else { return }
        let label = self.arrangedSubviews[index]
        label.removeFromSuperview()
    }
    
    func addLabel(client: Client) {
        let label = ListLabel(client: client)
        self.addArrangedSubview(label)
    }
}

final class ListLabel: UILabel {
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(client: Client) {
        super.init(frame: .zero)
        self.textAlignment = .center
        self.font = .preferredFont(forTextStyle: .title3)
        configure(client: client)
    }
    
    func configure(client: Client) {
        self.text = "\(client.number) - \(client.task)"
        switch client.task {
        case .deposit:
            self.textColor = .black
        case .loan:
            self.textColor = .purple
        }
    }
}
