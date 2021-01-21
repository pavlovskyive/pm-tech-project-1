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
        
        let solarSystemDetailedViewController = SolarSystemDetailedViewController()
        solarSystemDetailedViewController.solarSystem = solarSystem
        solarSystemDetailedViewController.timer = timer
        navigationController?.pushViewController(solarSystemDetailedViewController, animated: true)
    }
}
