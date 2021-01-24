//
//  SolarSystem.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 15.01.2021.
//

import Foundation

protocol SolarSystemDelegate: AnyObject {
    func handleDestruction(of solarSystem: SolarSystem)
}

final class SolarSystem {

    // MARK: - Variables

    // Star Delegate.
    weak var starDelegate: StarDelegate?

    // Solar System Delegates.
    private let delegates = MulticastDelegate<SolarSystemDelegate>()

    // Solar System name.
    private(set) var name: String

    // Age is used for time based methods.
    private(set) var age: UInt = 0

    // Host-Star of Solar System.
    private(set) var star: Star?

    // Planets in Solar System.
    private(set) var planets = [Planet]()

    var blackHoleThresholdMass: UInt?
    var blackHoleThresholdRadius: UInt?

    // MARK: - Lifecycle

    init(name: String) {
        self.name = name

        // Create Host-Star and asign its Solar System to this.
        star = Star(name: "\(name) Hosting Star",
                    blackHoleThresholdMass: blackHoleThresholdMass ?? 60,
                    blackHoleThresholdRadius: blackHoleThresholdRadius ?? 60)
        star?.delegate = self
    }
}

extension SolarSystem {

    // MARK: - Computed Variables

    // Mass of Solar System is computed as sum of Sun and all Planets (with sattelites) inside it.
    var mass: UInt {
        planets.reduce(star?.mass ?? 0) { $0 + $1.mass }
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
        let planet = Planet(name: "Planet \(planets.count + 1)", isSatellite: false)

        planets.append(planet)
    }
}

extension SolarSystem: TimerDelegate {

    // MARK: - Chain of Responsibility

    public func handleTick() {

        // Increase age of current Solar System.
        increaseAge()

        // Create new Planet every 10 seconds (until there are 9 Planets in current Solar System)
        if age % 10 == 1 && planets.count < 9 {
            newPlanet()
        }

        // Call updates on Host-Star.
        star?.handleTick()
    }
}

extension SolarSystem {
    // MARK: - Delegation

    public func addDelegate(delegate: SolarSystemDelegate) {
        delegates.add(delegate)
    }

    public func removeDelegate(delegate: SolarSystemDelegate) {
        delegates.remove(delegate)
    }
}

extension SolarSystem: StarDelegate {
    public func handleBecomingBlackHole(of star: Star) {

        starDelegate?.handleBecomingBlackHole(of: star)
        delegates.invoke { $0.handleDestruction(of: self) }
        self.star = nil
    }
}
