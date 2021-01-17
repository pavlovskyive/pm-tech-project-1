//
//  Star.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import Foundation

// Star types.
enum StarStage: String {
    case babyStar = "Baby Star"
    case oldStar = "Old Star"
    case dwarf = "Dwarf"
    case blackHole = "Black Hole"
}

class Star {
    
    // MARK: - Variables
    
    // Link to parent Solar System
    weak var solarSystem: SolarSystem?
    
    // Star name.
    private(set) var name: String
    
    // Age is used for time based methods.
    private(set) var age: UInt = 0
    
    // Star type.
//    private(set) var type: StarType
    
    // Current Star stage.
    private(set) var stage: StarStage = .babyStar
    
    // Mass of Star.
    private(set) var mass = UInt.random(in: 1...100)
    
    // Temperature of Star.
    private(set) var temperature = UInt.random(in: 1...100)
    
    // Radius of Star.
    private(set) var radius = UInt.random(in: 1...100)
    
    // Luminosity of Star.
    private(set) var luminosity = UInt.random(in: 1...100)
    
    // Threshold parameters for Star to became a Black Hole.
    private(set) var massThreshold: UInt
    private(set) var radiusThreshold: UInt
    
    // MARK: - Lifecycle
    init(name: String) {
        self.name = name
        
        // Set threshold parameters for Star to became a Black Hole from its Universe.
        massThreshold = solarSystem?.galaxy?.universe?.blackHoleThresholdMass ?? 60
        radiusThreshold = solarSystem?.galaxy?.universe?.blackHoleThresholdRadius ?? 60
    }
}

extension Star {
    
    // MARK: - Methods
    
    // Increase age of current Star.
    private func increaseAge() {
        age += 1
    }
    
    // Evolve to next Stage.
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
    
    // Get last stage based on Star parameters.
    private func getFinalStage() -> StarStage {
        if mass >= massThreshold && radius >= radiusThreshold {
            handleBecomingBlackHole()
            return .blackHole
        }
        return .dwarf
    }
    
    // Handle Star becoming Black Hole.
    private func handleBecomingBlackHole() {
//        print("Star became black hole!")
    }
}

extension Star: TimeHandler {
    
    // MARK: - Chain of Responsibility
    
    func handleTick() {
        
        // Increase age of current Star.
        increaseAge()
        
        // Evolve every minute.
        if age % 60 == 0 {
            nextStage()
        }
    }
}
