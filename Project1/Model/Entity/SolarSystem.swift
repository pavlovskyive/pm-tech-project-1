//
//  SolarSystem.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 15.01.2021.
//

import Foundation

class SolarSystem {
    
    private(set) var name: String
    private(set) var age: UInt = 0
    
    var mass: UInt {
        planets.reduce(star.mass) { $0 + $1.mass }
    }
    
    weak var galaxy: Galaxy?
    
    private(set) var star: Star
    private(set) var planets = [Planet]()
    
    init(name: String) {
        self.name = name
        star = Star(name: "Hosting Star")
        star.solarSystem = self
    }
}

extension SolarSystem {
    private func increaseAge() {
        age += 1
    }
    
    private func newPlanet() {
        let planet = Planet(name: "Planet \(planets.count + 1)", hostPlanet: nil)
        planet.solarSystem = self
        planets.append(planet)
    }
}

extension SolarSystem: TimeHandler {
    
    func handleTick() {
        increaseAge()
        
        if age % 10 == 1 && planets.count < 9 {
            newPlanet()
        }
        
        star.handleTick()
        
        planets.forEach { $0.handleTick() }
    }
}
