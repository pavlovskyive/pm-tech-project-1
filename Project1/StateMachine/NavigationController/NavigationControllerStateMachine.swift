//
//  NavigationControllerStateMachine.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

final class NavigationControllerStateMachine: StateMachine {

    private(set) var presenter: UINavigationController
    private(set) var storage: Storage
    private(set) var timer: RepeatingTimer

    init(presenter: UINavigationController,
         storage: Storage,
         timer: RepeatingTimer) {
        self.presenter = presenter
        self.storage = storage
        self.timer = timer
    }
}
