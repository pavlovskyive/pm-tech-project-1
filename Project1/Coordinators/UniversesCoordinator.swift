//
//  UniversesCoordinator.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

class UniversesCoordinator: Coordinator {

    private let presenter: UINavigationController
    private let storage: Storage
    private let timer: RepeatingTimer

    init(presenter: UINavigationController,
         storage: Storage,
         timer: RepeatingTimer) {
        self.presenter = presenter
        self.storage = storage
        self.timer = timer
    }

    func start() {
        let universesViewController = UniversesViewController(storage: storage, timer: timer)
        universesViewController.delegate = self
        presenter.pushViewController(universesViewController, animated: true)
    }

    deinit {
        print("deinited")
    }
}

extension UniversesCoordinator: UniversesViewControllerDelegate {
    func universesViewController(_ universesViewController: UniversesViewController,
                                 didSelectUniverse selectedUniverse: Universe) {
        NotificationCenter.default.post(name: Notification.Galaxies, object: selectedUniverse)
    }
}
