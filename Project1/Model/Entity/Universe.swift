//
//  Universe.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 14.01.2021.
//

import Foundation

final class Universe {

    // MARK: - Variables

    // Universe name.
    private(set) var name: String

    // Short name to identify itself in child's names.
    var shortName: String {
        guard let firstLetter = name.first,
              let number = Int(name.split(separator: " ").last ?? "") else {
            return ""
        }

        return "\(firstLetter)\(number)"
    }

    // Age is used for time based methods.
    private(set) var age: UInt = 0

    // Threshold parameters for Star to became a Black Hole.
    private(set) var blackHoleThresholdMass: UInt
    private(set) var blackHoleThresholdRadius: UInt

    private(set) var galaxies = [Galaxy]()

    // MARK: - Lifecycle

    init(name: String, blackHoleThresholdMass: UInt, blackHoleThresholdRadius: UInt) {
        self.name = name

        self.blackHoleThresholdMass = blackHoleThresholdMass
        self.blackHoleThresholdRadius = blackHoleThresholdRadius
    }
}

extension Universe {

    // MARK: - Methods

    // Increase age of current Universe.
    private func increaseAge() {
        age += 1
    }

    // Create new Galaxy in current Universe.
    private func newGalaxy() {
        let galaxy = Galaxy(name: "\(shortName)G\(galaxies.count + 1)")

        galaxy.blackHoleThresholdMass = blackHoleThresholdMass
        galaxy.blackHoleThresholdRadius = blackHoleThresholdRadius

        galaxies.append(galaxy)
    }

    // Handle Galaxies Collision
    private func handleGalaxiesCollision() {

        // Get Galaxies with life time more than 3 minutes in random order.
        var suitableGalaxies = galaxies.indices.filter { galaxies[$0].age >= 3 * 60 }.shuffled()

        // Check if there are more than 2 suitable Galaxies.
        guard suitableGalaxies.count >= 2 else {
            return
        }

        // Get 2 first random Galaxies and sort them by mass descending.
        suitableGalaxies = Array(suitableGalaxies.prefix(2)).sorted { galaxies[$0].mass > galaxies[$1].mass }

        // Call collide method on bigger Galaxy with smaller Galaxy.
        galaxies[suitableGalaxies[0]].collide(with: galaxies[suitableGalaxies[1]])

        // Remove destroyed galaxy.
        galaxies.remove(at: suitableGalaxies[1])
    }
}

extension Universe: TimerListener {

    // MARK: - Chain of Responsibility

    func handleTick() {

        // Increase age of current Universe.
        increaseAge()

        // Create new Galaxy every 10 seconds.
        if age % 10 == 1 {
            newGalaxy()
        }

        // Collide random 2 Galaxies with life time more that 3 minutes each 30 second.
        if age % 30 == 1 {
            handleGalaxiesCollision()
        }

        galaxies.forEach { $0.handleTick() }
    }
}
