//
//  Galaxy.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 14.01.2021.
//

import Foundation

// Galaxy types.
enum GalaxyType: String, CaseIterable {
    case elliptical = "Elliptical"
    case spiral = "Spiral"
    case irregular = "Irregular"
}

final class Galaxy {

    // MARK: - Variables

    // Link to parent Universe.
    weak var universe: Universe?

    // Galaxy name.
    private(set) var name: String

    // Age is used for time based methods and for display (as asked in assignment).
    private(set) var age: UInt = 0

    // Type of Galaxy.
    private(set) var type: GalaxyType

    // Solar systems inside current Galaxy.
    private(set) var solarSystems = [SolarSystem]()

    // Black holes inside current Galaxy.
    private(set) var blackHoles = [Star]()

    // MARK: - Lifecycle

    init(name: String) {
        self.name = name

        // Set type of current Galaxy to random type.
        type = GalaxyType.allCases.randomElement()!
    }
}

extension Galaxy {

    // MARK: - Computed Variables

    // Mass of Galaxy is computed as sum of all space objects inside it.
    var mass: UInt {
        solarSystems.reduce(0) { $0 + $1.mass }
    }
}

extension Galaxy {

    // MARK: - Private Methods

    // Increase age of current Galaxy.
    private func increaseAge() {
        age += 1
    }

    // Create new Solar System in current Galaxy.
    private func newSolarSystem() {
        let solarSystem = SolarSystem(name: "Solar System \(solarSystems.count + 1)")

        solarSystem.galaxy = self
        solarSystems.append(solarSystem)
    }

    // MARK: - Public Methods

    // Collide with another Galaxy.
    public func collide(with galaxy: Galaxy) {
        print("Galaxy (mass \(mass)) collides with galaxy (mass: \(galaxy.mass))")

        galaxy.solarSystems.forEach { $0.galaxy = self }
        galaxy.blackHoles.forEach { $0.galaxy = self}
        solarSystems.append(contentsOf: galaxy.solarSystems)
        blackHoles.append(contentsOf: galaxy.blackHoles)
        galaxy.solarSystems = []
        galaxy.blackHoles = []

        solarSystems.removeSubrange(0..<solarSystems.count / 10)
    }

    // Handle Star becoming Black Hole.
    public func handleBecomingBlackHole(of star: Star, in solarSystem: SolarSystem) {
        blackHoles.append(star)

        guard let index = solarSystems
                .firstIndex(where: { $0 === star.solarSystem }) else { return }

        solarSystems.remove(at: index)
    }
}

extension Galaxy: TimerListener {

    // MARK: - Chain of Responsibility

    func handleTick() {

        // Increase age of current Galaxy.
        increaseAge()

        // Create new Solar System every 10 seconds.
        if age % 10 == 1 {
            newSolarSystem()
        }

        // Call updates on every Solar System in current Galaxy.
        solarSystems.forEach { $0.handleTick() }
    }
}
