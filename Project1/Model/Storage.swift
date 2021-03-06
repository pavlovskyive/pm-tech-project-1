//
//  AppModel.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import Foundation

final class Storage {

    // MARK: - Variables

    // Storage.
    private(set) var universes = [Universe]()
}

extension Storage {

    // MARK: - Methods

    // Create Universe with given threshold parameters for Star to became a Black Hole.
    func createUniverse(name: String, blackHoleThresholdMass: UInt, blackHoleThresholdRadius: UInt) {
        if name.isEmpty {
            universes.append(
                Universe(
                    name: "Universe \(universes.count + 1)",
                    blackHoleThresholdMass: blackHoleThresholdMass,
                    blackHoleThresholdRadius: blackHoleThresholdRadius))
        } else {
            universes.append(
                Universe(
                    name: name,
                    blackHoleThresholdMass: blackHoleThresholdMass,
                    blackHoleThresholdRadius: blackHoleThresholdRadius))
        }
    }

    // Conveniense Universe creation with default threshold parameters for Star to became a Black Hole.
    func createUniverse() {
        let name = "Universe \(universes.count + 1)"
        createUniverse(
            name: name,
            blackHoleThresholdMass: 60,
            blackHoleThresholdRadius: 60)
    }
}

extension Storage: TimerDelegate {

    // MARK: - Chain of Responsibility.

    @objc func handleTick() {

        // Call updates on every Universe asynchronously.
        let queue = OperationQueue()

        for universe in universes {
            queue.addOperation {
                universe.handleTick()
            }
        }

        queue.waitUntilAllOperationsAreFinished()
    }
}
