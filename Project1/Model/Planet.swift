//
//  Planet.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import Foundation

class Planet {
    private(set) var name: String
    private(set) var age: UInt = 0
    
//    private(set) var type: PlanetType
    private(set) var selfMass: UInt
    private(set) var temperature: UInt
    private(set) var radius: UInt
    
    var mass: UInt {
        sattelites.reduce(selfMass) { $0 + $1.mass }
    }
    
    weak var hostPlanet: Planet? = nil
    weak var solarSystem: SolarSystem?
    
    private(set) var sattelites = [Planet]()
    
    init(name: String, hostPlanet: Planet?) {
        self.name = name
        
        selfMass = UInt.random(in: 1...100)
        temperature = UInt.random(in: 1...100)
        radius = UInt.random(in: 1...100)
        
        guard hostPlanet == nil else {
            return
        }
        
        var sattelitesNumber = Int.random(in: 0...5)
        while sattelitesNumber > 0 {
            sattelites.append(
                Planet(
                    name: "Sattelite \(sattelites.count)",
                    hostPlanet: self))
            sattelitesNumber -= 1
        }
    }
}

extension Planet {
    private func increaseAge() {
        age += 1
    }
}

extension Planet: TimeHandler {
    
    func handleTick() {
        increaseAge()
    }
}
