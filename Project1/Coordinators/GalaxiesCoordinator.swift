//
//  GalaxiesCoordinator.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

class GalaxiesCoordinator: Coordinator {

    private let presenter: UINavigationController
    private let universe: Universe?
    private let timer: RepeatingTimer

    init(presenter: UINavigationController,
         universe: Universe,
         timer: RepeatingTimer) {
        self.presenter = presenter
        self.universe = universe
        self.timer = timer
    }

    func start() {
        guard let universe = universe else {
            return
        }

        let galaxiesViewController = GalaxiesViewController(
            universe: universe,
            timer: timer,
            title: universe.name)

        galaxiesViewController.delegate = self
        presenter.pushViewController(galaxiesViewController, animated: true)
    }
}

extension GalaxiesCoordinator: GalaxiesViewControllerDelegate {
    func galaxiesViewController(_ galaxiesViewController: GalaxiesViewController,
                                didSelectGalaxy selectedGalaxy: Galaxy) {
        NotificationCenter.default.post(name: Notification.SolarSystems, object: selectedGalaxy)
    }
}
