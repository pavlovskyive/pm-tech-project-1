//
//  NavigationControllerStateMachine.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

enum PresentStyle {
    case pop,
         push
}

final class NavigationControllerStateMachine: StateMachine {

    private(set) var presenter: UINavigationController
    private(set) var storage: Storage
    private(set) var timer: RepeatingTimer

    func present(_ viewController: UIViewController, with presentStyle: PresentStyle) {

        switch presentStyle {
        case .pop:
            presenter.popToViewController(viewController, animated: true)
        case .push:
            presenter.pushViewController(viewController, animated: true)
        }
    }

    init(presenter: UINavigationController,
         storage: Storage,
         timer: RepeatingTimer) {
        self.presenter = presenter
        self.storage = storage
        self.timer = timer
    }
}
