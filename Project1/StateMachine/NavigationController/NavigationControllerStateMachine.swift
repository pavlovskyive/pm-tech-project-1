//
//  NavigationControllerStateMachine.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

class NavigationControllerStateMachine: StateMachine {

    var presenter: UINavigationController
    var storage: Storage
    var timer: RepeatingTimer

    init(presenter: UINavigationController,
         storage: Storage,
         timer: RepeatingTimer) {
        self.presenter = presenter
        self.storage = storage
        self.timer = timer
    }
}
