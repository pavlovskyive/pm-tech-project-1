//
//  GalaxiesViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import UIKit

class GalaxiesViewController: BaseViewController {

    var universe: Universe?

    override func setupNavigationBar() {
        super.setupNavigationBar()

        title =  "\(universe?.shortName ?? "") Galaxies"

        navigationItem.leftBarButtonItem = UIBarButtonItem(
            title: "Back", style: .plain, target: self, action: #selector(handleBackButton))
    }

    override func getCellCount() -> Int {
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
            image = UIImage(systemName: "record.circle")!
        default:
            image = UIImage(systemName: "aqi.low")!
        }

        cell.titleLabel.text = name
        cell.secondaryLabel.text = "Age: \(age)\nType: \(type)\nMass: \(mass)"
        cell.iconImageView.image = UIImage(systemName: "camera.filters")
        cell.iconImageView.image = image

        return cell
    }

    override func handleCellSelection(indexPath: IndexPath) {
        guard let galaxy = universe?.galaxies[indexPath.row] else {
            return
        }

        let solarSystemsState = SolarSystemsState()
        solarSystemsState.galaxy = galaxy
        stateMachine?.enter(solarSystemsState)
    }
}

extension GalaxiesViewController {

    @objc func handleBackButton() {
        stateMachine?.enter(UniversesState())
    }
}
