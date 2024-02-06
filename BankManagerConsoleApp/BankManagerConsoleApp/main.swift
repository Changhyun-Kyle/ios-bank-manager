//
//  BankManagerConsoleApp - main.swift
//  Created by yagom.
//  Copyright © yagom academy. All rights reserved.
//

let console = ConsoleManager()
let bankManager = BankManagerApp(inputHandler: console, outputHandler: console)
bankManager?.start()
