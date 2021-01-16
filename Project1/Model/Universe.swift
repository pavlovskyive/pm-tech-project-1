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
    func increaseAge() {
        age += 1
    }
    
    func newGalaxy() {
        let galaxy = Galaxy(name: "Galaxy \(galaxies.count + 1)")
        galaxy.universe = self
        galaxies.append(galaxy)
        
        print("New galaxy in \(name): \(galaxy.name) ")
    }
}

extension Universe: TimeHandler {
    func handleTick() {
        increaseAge()
        
        if age % 10 == 1 {
            newGalaxy()
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
