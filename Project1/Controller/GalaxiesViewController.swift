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

        let representation = galaxy.cellRepresentation

        cell.titleLabel.text = representation.name
        cell.secondaryLabel.text = representation.description
        cell.iconImageView.image = representation.icon

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
