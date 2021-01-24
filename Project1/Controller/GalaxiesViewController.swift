//
//  GalaxiesViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import UIKit

class GalaxiesViewController: BaseViewController {

    var universe: Universe?

    override var backgroundImage: UIImage? {
        get {
            return UIImage(named: "GalaxiesBackground")
        }
        set {
            super.backgroundImage = newValue
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        title = "\(universe?.shortName ?? "") Galaxies"
    }

    override func getCellCount(for section: Int) -> Int {
        universe?.galaxies.count ?? 0
    }

    override func setupCell(cell: RoundedCollectionViewCell, indexPath: IndexPath) -> RoundedCollectionViewCell {
        guard let galaxy = universe?.galaxies[indexPath.row] else {
            return cell
        }

        let name = galaxy.name
        let age = galaxy.age
        let type = galaxy.type.rawValue
        let mass = galaxy.mass

        var image: UIImage

        switch galaxy.type {
        case .spiral:
            image = UIImage(systemName: "hurricane")!
        case .elliptical:
            image = UIImage(systemName: "circlebadge.fill")!
        default:
            image = UIImage(systemName: "aqi.low")!
        }

        cell.titleLabel.text = name
        cell.secondaryLabel.text = "Type: \(type)\nAge: \(age)\nMass: \(mass)"
        cell.iconImageView.image = image

        return cell
    }

    override func handleCellSelection(indexPath: IndexPath) {

        guard let galaxy = universe?.galaxies[indexPath.row] else {
            return
        }

        let solarSystemsViewController = GalaxyViewController()
        solarSystemsViewController.galaxy = galaxy
        solarSystemsViewController.timer = timer
        navigationController?.pushViewController(solarSystemsViewController, animated: true)
    }
}
