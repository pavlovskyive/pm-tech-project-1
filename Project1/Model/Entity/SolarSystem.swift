//
//  SolarSystem.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 15.01.2021.
//

import Foundation

final class SolarSystem {

    // MARK: - Variables

    // Link to parent Galaxy.
    weak var galaxy: Galaxy?

    // Solar System name.
    private(set) var name: String

    // Age is used for time based methods.
    private(set) var age: UInt = 0

    // Host-Star of Solar System.
    private(set) var star: Star

    // Planets in Solar System.
    private(set) var planets = [Planet]()

    // MARK: - Lifecycle

    init(name: String) {
        self.name = name

        // Create Host-Star and asign its Solar System to this.
        star = Star(name: "Hosting Star")
        star.solarSystem = self
    }
}

extension SolarSystem {

    // MARK: - Computed Variables

    // Mass of Solar System is computed as sum of Sun and all Planets (with sattelites) inside it.
    var mass: UInt {
        planets.reduce(star.mass) { $0 + $1.mass }
    }
}

extension SolarSystem {

    // MARK: - Methods

    // Increase age of current Solar System.
    private func increaseAge() {
        age += 1
    }

    // Create new Planet in current Solar System.
    private func newPlanet() {
        let planet = Planet(name: "Planet \(planets.count + 1)")

        planet.solarSystem = self
        planets.append(planet)
    }
}

extension SolarSystem: TimeHandler {

    // MARK: - Chain of Responsibility

    func handleTick() {

        // Increase age of current Solar System.
        increaseAge()

        // Create new Planet every 10 seconds (until there are 9 Planets in current Solar System)
        if age % 10 == 1 && planets.count < 9 {
            newPlanet()
        }

        // Call updates on Host-Star.
        star.handleTick()
    }
}
