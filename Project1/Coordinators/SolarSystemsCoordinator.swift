//
//  SolarSystemsCoordinator.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

class SolarSystemsCoordinator: Coordinator {

    private let presenter: UINavigationController
    private let galaxy: Galaxy?
    private let timer: RepeatingTimer

    init(presenter: UINavigationController,
         galaxy: Galaxy,
         timer: RepeatingTimer) {
        self.presenter = presenter
        self.galaxy = galaxy
        self.timer = timer
    }

    func start() {
        guard let galaxy = galaxy else {
            return
        }

        let solarSystemsViewController = SolarSystemsViewController(galaxy: galaxy, timer: timer)

        solarSystemsViewController.delegate = self
        presenter.pushViewController(solarSystemsViewController, animated: true)
    }
}

extension SolarSystemsCoordinator: SolarSystemsViewControllerDelegate {
    func solarSystemsViewController(_ solarSystemsViewController: SolarSystemsViewController,
                                    didSelectSolarSystem selectedSolarSystem: SolarSystem) {
        NotificationCenter.default.post(name: Notification.SolarSystemDetailed, object: selectedSolarSystem)
    }
}
