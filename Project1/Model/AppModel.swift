//
//  AppModel.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import Foundation

class AppModel {
    private(set) var universes = [Universe]()
}

extension AppModel {

    func createUniverse(name: String, blackHoleThresholdMass: UInt, blackHoleThresholdRadius: UInt) {
        if name.isEmpty {
            universes.append(
                Universe(
                    name: "New Universe \(universes.count + 1)",
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
    
    func createUniverse(name: String) {
        createUniverse(
            name: name,
            blackHoleThresholdMass: 60,
            blackHoleThresholdRadius: 60)
    }
}

extension AppModel: TimeHandler {
    func handleTick() {
        universes.indices.forEach {
            universes[$0].handleTick()
        }
    }
}
