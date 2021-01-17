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

enum StarType: String, CaseIterable {
    case solar = "Solar"
    case hotBlue = "Hot Blue"
    case red = "Red"
    case white = "White"
}

class Star {
    
    // MARK: - Variables
    
    // Link to parent Solar System
    weak var solarSystem: SolarSystem?
    weak var galaxy: Galaxy? = nil
    
    // Star name.
    private(set) var name: String
    
    // Age is used for time based methods.
    private(set) var age: UInt = 0
    
    // Star type.
    private(set) var type = StarType.allCases.randomElement()!
    
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
        print("Star became a Black Hole!")
        
        guard let galaxy = solarSystem?.galaxy else { return }
        galaxy.handleBecomingBlackHole(of: self, in: solarSystem!)
        solarSystem = nil
    }
}

extension Star: TimeHandler {
    
    // MARK: - Chain of Responsibility
    
    func handleTick() {
        
        // It is not neccessary to change Star age or stage after it's on final stage.
        if stage == .dwarf || stage == .blackHole {
            return
        }
        
        // Increase age of current Star.
        increaseAge()
        
        // Evolve every minute.
        if age % 60 == 0 {
            nextStage()
        }
    }
}
