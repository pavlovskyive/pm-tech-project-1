//
//  SolarSystemsViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import UIKit

class GalaxyViewController: BaseViewController {

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

    override func viewDidAppear(_ animated: Bool) {
        super.viewWillAppear(animated)

        galaxy?.delegate = self
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        galaxy?.delegate = nil
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        title = "\(galaxy?.name ?? "") Galaxy"
    }

    override func getSectionsCount() -> Int {
        return 2
    }

    override func getCellCount(for section: Int) -> Int {
        switch section {
        case 0:
            return galaxy?.storage.filter { $0 is SolarSystem }.count ?? 0
        case 1:
            return galaxy?.storage.filter { $0 is Star }.count ?? 0
        default:
            return 0
        }
    }

    override func setupCell(cell: RoundedCollectionViewCell, indexPath: IndexPath) -> RoundedCollectionViewCell {

        switch indexPath.section {
        case 0:
            return cellForSolarSystem(cell: cell, indexPath: indexPath)
        case 1:
            return cellForBlackHole(cell: cell, indexPath: indexPath)
        default:
            fatalError("Implement more types here")
        }
    }

    private func cellForSolarSystem(
        cell: RoundedCollectionViewCell,
        indexPath: IndexPath) -> RoundedCollectionViewCell {

        guard galaxy?.storage.count ?? 0 > indexPath.row else {
            return cell
        }

        guard let solarSystems = galaxy?.storage.filter({ $0 is SolarSystem }),
              solarSystems.count > indexPath.row,
              let solarSystem = solarSystems[indexPath.row] as? SolarSystem else {
            return cell
        }

        let representation = solarSystem.cellRepresentation

        cell.titleLabel.text = representation.name
        cell.secondaryLabel.text = representation.description
        cell.iconImageView.image = representation.icon

        return cell
    }

    private func cellForBlackHole(
        cell: RoundedCollectionViewCell,
        indexPath: IndexPath) -> RoundedCollectionViewCell {

        guard let blackHoles = galaxy?.storage.filter({ $0 is Star }),
              blackHoles.count > indexPath.row,
              let blackHole = blackHoles[indexPath.row] as? Star else {
            return cell
        }

        let representation = blackHole.cellRepresentation

        cell.titleLabel.text = representation.name
        cell.secondaryLabel.text = representation.description
        cell.iconImageView.image = representation.icon

        return cell
    }

    override func handleCellSelection(indexPath: IndexPath) {

        guard let solarSystem = galaxy?.storage.filter({ $0 is SolarSystem })[indexPath.row] as? SolarSystem else {
            return
        }

        let solarSystemDetailedViewController = SolarSystemDetailedViewController()
        solarSystemDetailedViewController.solarSystem = solarSystem
        solarSystemDetailedViewController.timer = timer
        navigationController?.pushViewController(solarSystemDetailedViewController, animated: true)
    }
}

extension GalaxyViewController: GalaxyDelegate {
    func handleDestruction(of galaxy: Galaxy) {
        if galaxy === self.galaxy {
            self.galaxy = nil
            DispatchQueue.main.async { [weak self] in
                self?.timer?.suspend()
                self?.navigationController?.popViewController(animated: true)
                self?.showAlert(title: "Current Galaxy has been destroyed",
                          message: "You've been redirected to previous screen")
            }
        }
    }
}
