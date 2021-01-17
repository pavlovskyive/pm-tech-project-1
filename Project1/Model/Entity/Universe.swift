//
//  Universe.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 14.01.2021.
//

import Foundation

class Universe {
    
    private(set) var name: String
    private(set) var age: UInt = 0
    
    private(set) var blackHoleThresholdMass: UInt
    private(set) var blackHoleThresholdRadius: UInt
    
    private(set) var galaxies = [Galaxy]()
    
    init(name: String, blackHoleThresholdMass: UInt, blackHoleThresholdRadius: UInt) {
        self.name = name
        
        self.blackHoleThresholdMass = blackHoleThresholdMass
        self.blackHoleThresholdRadius = blackHoleThresholdRadius
    }
}

extension Universe {
    private func increaseAge() {
        age += 1
    }
    
    private func newGalaxy() {
        let galaxy = Galaxy(name: "Galaxy \(galaxies.count + 1)")
        galaxy.universe = self
        galaxies.append(galaxy)
    }
    
    private func handleGalaxiesCollision() {
        var suitableGalaxies = galaxies.indices.filter { galaxies[$0].age >= 3 * 60 }.shuffled()
        
        guard suitableGalaxies.count >= 2 else {
            return
        }
        
        suitableGalaxies = Array(suitableGalaxies.prefix(2)).sorted { galaxies[$0].mass > galaxies[$1].mass }
        galaxies[suitableGalaxies[0]].collide(with: galaxies[suitableGalaxies[1]])
        
        galaxies.remove(at: suitableGalaxies[1])
    }
}

extension Universe: TimeHandler {
    func handleTick() {
        increaseAge()
        
        if age % 10 == 1 {
            newGalaxy()
        }
        
        if age % 30 == 1 {
            handleGalaxiesCollision()
        }
        
        let queue = OperationQueue()
        
        for galaxy in galaxies {
            queue.addOperation {
                galaxy.handleTick()
            }
        }
        
        queue.waitUntilAllOperationsAreFinished()
        
//        galaxies.forEach { $0.handleTick() }
    }
}
