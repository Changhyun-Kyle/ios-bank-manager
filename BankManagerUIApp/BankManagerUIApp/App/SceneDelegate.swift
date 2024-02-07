//
//  BankManagerUIApp - SceneDelegate.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

import UIKit

final class SceneDelegate: UIResponder, UIWindowSceneDelegate {
    var window: UIWindow?
    
    func scene(
        _ scene: UIScene,
        willConnectTo session: UISceneSession,
        options connectionOptions: UIScene.ConnectionOptions
    ) {
        guard let windowScene = (scene as? UIWindowScene) else { return }
        self.window = UIWindow(windowScene: windowScene)
        self.window?.rootViewController = Self.makeViewController()
        self.window?.makeKeyAndVisible()
    }
    
    static func makeViewController() -> UIViewController {
        let orders = [
            Order(taskType: .loan, bankerCount: 1),
            Order(taskType: .deposit, bankerCount: 2),
        ]
        
        var taskManagers = [BankTask: TaskManagable]()
        
        for order in orders {
            let taskManager = TaskManager()
            (1...order.bankerCount).forEach { _ in
                var banker = Banker()
                banker.delegate = taskManager
                taskManager.enqueueBanker(banker)
            }
            taskManagers.updateValue(taskManager, forKey: order.taskType)
            
        }
        
        let bankManager = BankManager(taskManagers: taskManagers)
        
        for (type, taskManager) in taskManagers {
            guard let taskManager = taskManager as? TaskManager else { 
                continue
            }
            taskManager.delegate = bankManager
        }
        
        let mirror = BankMirror(bankManager: bankManager)
        bankManager.delegate = mirror
        
        let viewController = ViewController(bankMirror: mirror)
        mirror.delegate = viewController
        return viewController
    }
}
