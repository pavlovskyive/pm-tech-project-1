//
//  ModelDecorator.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 04.02.2021.
//

import UIKit

typealias CellData = (icon: UIImage?, name: String, description: String)

protocol CellRepresentable {
    var cellRepresentation: CellData { get }
}

extension Universe: CellRepresentable {
    var cellRepresentation: CellData {
        let description = "Time since \ncreation: \(age)"
        let icon = UIImage(systemName: "infinity")

        return (icon, name, description)
    }
}

extension Galaxy: CellRepresentable {
    var cellRepresentation: CellData {
        let description = "Type: \(type)\nAge: \(age)\nMass: \(mass)"

        var image: UIImage?

        switch type {
        case .spiral:
            image = UIImage(systemName: "hurricane")
        case .elliptical:
            image = UIImage(systemName: "circlebadge.fill")
        default:
            image = UIImage(systemName: "aqi.low")
        }

        return (image, name, description)
    }
}

extension SolarSystem: CellRepresentable {
    var cellRepresentation: CellData {
        let starType = star?.type.rawValue ?? ""
        let planetNumber = planets.count

        let description = "Star Type: \(starType)\n" +
            "Number of Planets: \(planetNumber)"
        let image = UIImage(systemName: "smallcircle.fill.circle")

        return (image, name, description)
    }
}

extension Star: CellRepresentable {
    var cellRepresentation: CellData {

        var description: String
        var image: UIImage?

        switch stage {
        case .blackHole:
            description = "Stage: Black Hole"
            image = UIImage(systemName: "smallcircle.fill.circle.fill")
        default:
            description = "Type: \(type.rawValue)\n" + "Evolution Stage: \(stage.rawValue)\n" +
                "Mass: \(mass)    Temperature: \(temperature)\n" +
                "Radius: \(radius)    Luminosity: \(luminosity)"
            image = UIImage(systemName: "smallcircle.fill.circle")
        }

        return (image, name, description)
    }
}

extension Planet: CellRepresentable {
    var cellRepresentation: CellData {

        let desctiption = "Type: \(type)\nMass: \(mass)\nSattelites: \(sattelites.count)"
        let image = UIImage(systemName: "globe")

        return (image, name, desctiption)
    }
}
