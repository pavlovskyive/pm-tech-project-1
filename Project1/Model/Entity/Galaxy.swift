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
    
    var blackHoleThresholdMass: UInt?
    var blackHoleThresholdRadius: UInt?

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
        let solarSystemName = "\(name)S\(solarSystems.count + 1)"
        let solarSystem = SolarSystem(name: solarSystemName)

        solarSystems.append(solarSystem)
    }

    // MARK: - Public Methods

    // Collide with another Galaxy.
    public func collide(with galaxy: Galaxy) {
        print("Galaxy (mass \(mass)) collides with galaxy (mass: \(galaxy.mass))")

        solarSystems.append(contentsOf: galaxy.solarSystems)
        blackHoles.append(contentsOf: galaxy.blackHoles)
        galaxy.solarSystems.removeAll()
        galaxy.blackHoles.removeAll()

        solarSystems.removeSubrange(0..<solarSystems.count / 10)
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

extension Galaxy: StarDelegate {
    func handleBecomingBlackHole(of star: Star) {
        blackHoles.append(star)
    }
}

extension Galaxy: SolarSystemDelegate {
    func handleDestruction(of solarSystem: SolarSystem) {
        
        let index = solarSystems.firstIndex { $0 === solarSystem}
        if index != nil {
            solarSystems.remove(at: index!)
        }
    }
}
