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
    private(set) var mass: UInt
    private(set) var temperature: UInt
    private(set) var radius: UInt
    
    weak var hostPlanet: Planet? = nil
    weak var solarSystem: SolarSystem?
    
    private(set) var sattelites = [Planet]()
    
    init(name: String, hostPlanet: Planet?) {
        self.name = name
        
        mass = UInt.random(in: 1...100)
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
