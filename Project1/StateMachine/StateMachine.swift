//
//  StateMachine.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit
import GameplayKit.GKStateMachine

class StateMachine: GKStateMachine {
    var presenter: UINavigationController
    var storage: Storage
    var timer: RepeatingTimer

    init(presenter: UINavigationController,
         storage: Storage,
         timer: RepeatingTimer,
         states: [GKState]) {
        self.presenter = presenter
        self.storage = storage
        self.timer = timer

        super.init(states: states)
    }
}
