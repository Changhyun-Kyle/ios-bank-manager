//
//  BankManagerUIApp - ViewController.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import UIKit

final class ViewController: UIViewController {
    private let timerView = TimerView()
    
    private let waitingQueueView = QueueView(type: .waiting)
    
    private let workingQueueView = QueueView(type: .working)
    
    private lazy var queueStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            waitingQueueView,
            workingQueueView,
        ])
        stackView.axis = .horizontal
        stackView.spacing = 0
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private lazy var buttonStackView: UIStackView = {
        let stackView = UIStackView(arrangedSubviews: [
            addClientButton,
            clearButton,
            startButton,
        ])
        stackView.axis = .horizontal
        stackView.spacing = 5
        stackView.distribution = .fillEqually
        return stackView
    }()
    
    private let startButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.text = "시작"
        return button
    }()
    
    private let clearButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.text = "초기화"
        button.tintColor = .red
        return button
    }()
    
    private let addClientButton: UIButton = {
        let button = UIButton(frame: .zero)
        button.titleLabel?.text = "고객 10명 추가"
        return button
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .white
        setLayout()
    }
    
    private func setLayout() {
        let stack = UIStackView(arrangedSubviews: [
            buttonStackView,
            timerView,
            queueStackView
        ])
        stack.axis = .vertical
        self.view = stack
        view.backgroundColor = .white
    }
}
extension UIView {
    func addSubviews(_ views: UIView...){
        for view in views {
            self.addSubview(view)
        }
    }
}
enum BankQueue {
    case waiting
    case working
    
    var backgroundColor: UIColor {
        switch self {
        case .waiting: return .green
        case .working: return .purple
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
        label.font = .preferredFont(forTextStyle: .title3)
        return label
    }()
    
    private func setLayout() {
        self.addSubview(timerLabel)
        NSLayoutConstraint.activate([
            self.timerLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor, constant: 10),
            self.timerLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor, constant: 10),
            self.timerLabel.topAnchor.constraint(equalTo: self.topAnchor, constant: 10),
            self.timerLabel.bottomAnchor.constraint(equalTo: self.bottomAnchor, constant: 10),
        ])
    }
    
}

final class QueueView: UIView {
    private let titleLabel: UILabel = {
        let label = UILabel(frame: .zero)
        label.font = .preferredFont(forTextStyle: .title1)
        return label
    }()
    
    private let list: ListStackView = ListStackView()
    
    @available(*, unavailable)
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    init(type: BankQueue) {
        super.init(frame: .zero)
        self.titleLabel.text = type.name
        self.backgroundColor = type.backgroundColor
    }
    
    private func setLayout() {
        self.addSubview(self.titleLabel)
        self.addSubview(self.list)
        
        NSLayoutConstraint.activate([
            self.titleLabel.leadingAnchor.constraint(equalTo: self.leadingAnchor),
            self.titleLabel.trailingAnchor.constraint(equalTo: self.trailingAnchor),
            self.titleLabel.topAnchor.constraint(equalTo: self.topAnchor),
            
            self.list.topAnchor.constraint(equalTo: self.titleLabel.bottomAnchor, constant: 10),
            self.list.centerXAnchor.constraint(equalTo: self.centerXAnchor),
            self.list.bottomAnchor.constraint(equalTo: self.bottomAnchor),
        ])
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
        self.spacing = 5
        self.alignment = .top
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
