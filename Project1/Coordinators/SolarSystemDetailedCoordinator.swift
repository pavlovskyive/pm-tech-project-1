//
//  SolarSystemDetailedCoordinator.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

class SolarSystemDetailedCoordinator: Coordinator {

    private let presenter: UINavigationController
    private let solarSystem: SolarSystem?
    private let timer: RepeatingTimer

    init(presenter: UINavigationController,
         solarSystem: SolarSystem,
         timer: RepeatingTimer) {
        self.presenter = presenter
        self.solarSystem = solarSystem
        self.timer = timer
    }

    func start() {
        guard let solarSystem = solarSystem else {
            return
        }

        let solarSystemDetailedViewController = SolarSystemDetailedViewController(
            solarSystem: solarSystem, timer: timer)

        presenter.pushViewController(solarSystemDetailedViewController, animated: true)
    }
}
