//
//  SolarSystemsViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import UIKit

class SolarSystemsViewController: BaseViewController {

    var galaxy: Galaxy?

    override var backgroundImage: UIImage? {
        get {
            switch galaxy?.type {
            case .elliptical:
                return UIImage(named: "EllipticalGalaxyBackground")
            case .irregular:
                return UIImage(named: "IrregularGalaxyBackground")
            case .spiral:
                return UIImage(named: "SpiralGalaxyBackground")
            default:
                fatalError("Expand here")
            }
        }
        set {
            super.backgroundImage = newValue
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        title = "\(galaxy?.name ?? "") Solar Systems"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back", style: .plain, target: self, action: #selector(handleBackButton))
    }

    override func getCellCount() -> Int {
        galaxy?.solarSystems.count ?? 0
    }

    override func setupCell(cell: RoundedCollectionViewCell, indexPath: IndexPath) -> RoundedCollectionViewCell {

        guard let solarSystem = galaxy?.solarSystems[indexPath.row] else {
            return cell
        }

        let name = solarSystem.name
        let age = solarSystem.age
        let mass = solarSystem.mass

        cell.titleLabel.text = name
        cell.secondaryLabel.text = "Age: \(age)\nMass: \(mass)"
        cell.iconImageView.image = UIImage(systemName: "camera.filters")
        return cell
    }

    override func handleCellSelection(indexPath: IndexPath) {
        guard let solarSystem = galaxy?.solarSystems[indexPath.row] else {
            return
        }

        let solarSystemDetailedState = SolarSystemDetailedState()
        solarSystemDetailedState.solarSystem = solarSystem
        stateMachine?.enter(solarSystemDetailedState)
    }
}

extension SolarSystemsViewController {

    @objc func handleBackButton() {
        guard let galaxy = galaxy else {
            return
        }

        let galaxiesState = GalaxiesState()
        galaxiesState.universe = galaxy.universe
        stateMachine?.enter(galaxiesState)
    }
}
