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

protocol StarDelegate: AnyObject {
    func handleBecomingBlackHole(of star: Star)
}

final class Star {

    // MARK: - Variables

    // Star delegate.
    weak var delegate: StarDelegate?

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
    init(name: String,
         blackHoleThresholdMass: UInt,
         blackHoleThresholdRadius: UInt) {
        self.name = name

        self.massThreshold = blackHoleThresholdMass
        self.radiusThreshold = blackHoleThresholdRadius
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
            /*
             Mentor's comment:
             This isn't a mistake, but I'd rather move this line somewhere else.
             Why? I think by placing this code here u introduce a side effect for this simple
             function which may be unexpected keeping it's name in mind.
             
             Look for some info about pure functions. Even if we're not diving deep into functional programming,
             there are still some concepts to keep in mind for the sake of readability and maintainability.
             */
            handleBecomingBlackHole()
            return .blackHole
        }
        return .dwarf
    }

    // Handle Star becoming Black Hole.
    private func handleBecomingBlackHole() {
        print("\(name) becomes a Black Hole")
        self.name = "Ex " + String(name.split(separator: " ").first ?? "") + " BH"
        delegate?.handleBecomingBlackHole(of: self)
    }
}

extension Star: TimerDelegate {

    // MARK: - Chain of Responsibility

    public func handleTick() {

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

extension Star: GalaxyContainable {

}
