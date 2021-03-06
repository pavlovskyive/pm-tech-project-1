//
//  Planet.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import Foundation

// Planet types.
enum PlanetType: String, CaseIterable {
    case terrestrial = "Terrestial"
    case gasGiant = "Gas Giant"
    case iceGiant = "Ice Giant"
    case dwarf = "Dwarf"
}

class Planet {

    // MARK: - Variables

    // Planet name.
    private(set) var name: String

    // Planet type (sets randomly).
    private(set) var type = PlanetType.allCases.randomElement()!

    // Mass of current Planet.
    private(set) var selfMass = UInt.random(in: 1...100)

    // Temperature of Planet.
    private(set) var temperature = UInt.random(in: 1...100)

    // Radius of Planet.
    private(set) var radius = UInt.random(in: 1...100)

    // Sattelites of Planet (if current Planet is not a Sattelite).
    private(set) var sattelites = [Planet]()

    // MARK: - Lifecycle

    // Init for Planet.
    init(name: String, isSatellite: Bool) {

        self.name = name

        guard isSatellite == false else {
            return
        }

        // Get random number of sattelites.
        var sattelitesNumber = Int.random(in: 0...5)

        // Append Sattelites.
        while sattelitesNumber > 0 {
            sattelites.append(
                Planet(name: "Sattelite \(sattelites.count)", isSatellite: true))
            sattelitesNumber -= 1
        }
    }
}

extension Planet {

    // MARK: - Computed Variables

    // Full mass of Planet is computed as sum of its mass and masses of its Sattelites.
    var mass: UInt {
        sattelites.reduce(selfMass) { $0 + $1.mass }
    }
}
