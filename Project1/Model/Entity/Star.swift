//
//  Star.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import Foundation

enum StarStage: String {
    case babyStar = "Baby Star"
    case oldStar = "Old Star"
    case dwarf = "Dwarf"
    case blackHole = "Black Hole"
}

class Star {
    private(set) var name: String
    private(set) var age: UInt = 0
//    private(set) var type: StarType
    private(set) var stage: StarStage = .babyStar
    private(set) var mass: UInt
    private(set) var temperature: UInt
    private(set) var radius: UInt
    private(set) var luminosity: UInt
    
    private(set) var massThreshold: UInt
    private(set) var radiusThreshold: UInt
    
    weak var solarSystem: SolarSystem?
    
    init(name: String) {
        self.name = name
        
        mass = UInt.random(in: 1...100)
        temperature = UInt.random(in: 1...100)
        radius = UInt.random(in: 1...100)
        luminosity = UInt.random(in: 1...100)
        
        massThreshold = solarSystem?.galaxy?.universe?.blackHoleThresholdMass ?? 60
        radiusThreshold = solarSystem?.galaxy?.universe?.blackHoleThresholdRadius ?? 60
    }
}

extension Star {
    private func increaseAge() {
        age += 1
    }
    
    private func nextStage() {
        switch stage {
        case .babyStar:
            stage = .oldStar
        case .oldStar:
            stage = getFinalStage()
        default:
            return
        }
    }
    
    private func getFinalStage() -> StarStage {
        if mass >= massThreshold && radius >= radiusThreshold {
            handleBecomingBlackHole()
            return .blackHole
        }
        return .dwarf
    }
    
    private func handleBecomingBlackHole() {
//        print("Star became black hole!")
    }
}

extension Star: TimeHandler {
    
    func handleTick() {
        increaseAge()
        
        if age % 60 == 0 {
            nextStage()
        }
    }
}
