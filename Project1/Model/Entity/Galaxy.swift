//
//  Galaxy.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 14.01.2021.
//

import Foundation

enum GalaxyType: String, CaseIterable {
    case elliptical = "Elliptical"
    case spiral = "Spiral"
    case irregular = "Irregular"
}

class Galaxy {
    private(set) var name: String
    private(set) var age: UInt = 0
    private(set) var type: GalaxyType
    
    weak var universe: Universe?
    
    private(set) var solarSystems = [SolarSystem]()
    
    var mass: UInt {
        solarSystems.reduce(0) { $0 + $1.mass }
    }
    
    init(name: String) {
        self.name = name
        type = GalaxyType.allCases.randomElement()!
    }
}

extension Galaxy {
    func increaseAge() {
        age += 1
    }
    
    func newSolarSystem() {
        let solarSystem = SolarSystem(name: "Solar System \(solarSystems.count + 1)")
        solarSystem.galaxy = self
        solarSystems.append(solarSystem)
    }
    
    func collide(with galaxy: Galaxy) {
        print("Galaxy (mass \(mass)) collides with galaxy (mass: \(galaxy.mass))")
        
        galaxy.solarSystems.forEach { $0.galaxy = self }
        solarSystems.append(contentsOf: galaxy.solarSystems)
        galaxy.solarSystems = []

        solarSystems.removeSubrange(0..<solarSystems.count / 10)
    }
}

extension Galaxy: TimeHandler {
    func handleTick() {
        increaseAge()
        
        if age % 10 == 1 {
            newSolarSystem()
        }
        
        solarSystems.forEach { $0.handleTick() }
    }
}
