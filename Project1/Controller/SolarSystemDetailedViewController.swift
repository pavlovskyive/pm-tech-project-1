//
//  SolarSystemDetailedViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import UIKit

class SolarSystemDetailedViewController: BaseViewController {

    var solarSystem: SolarSystem?

    var timerControl: TimerSegmentedControl?

    override var backgroundImage: UIImage? {
        get {
            return UIImage(named: "SolarSystemBackground")
        }
        set {
            super.backgroundImage = newValue
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        title = "Solar System \(solarSystem?.name ?? "")"
    }

    override func setCollectionView() -> DoubleColumnCollectionView {
        return DoubleColumnCollectionViewWithHeader()
    }

    override func getCellCount() -> Int {
        solarSystem?.planets.count ?? 0
    }

    override func setupCell(cell: RoundedCollectionViewCell, indexPath: IndexPath) -> RoundedCollectionViewCell {

        guard let planet = solarSystem?.planets[indexPath.row] else {
            return cell
        }

        let name = planet.name
        let mass = planet.mass

        cell.titleLabel.text = name
        cell.secondaryLabel.text = "Mass: \(mass)"
        cell.iconImageView.image = UIImage(systemName: "camera.filters")

        return cell
    }

    override func handleCellSelection(indexPath: IndexPath) {}
}

extension SolarSystemDetailedViewController {

    func collectionView(_ collectionView: UICollectionView,
                        viewForSupplementaryElementOfKind kind: String,
                        at indexPath: IndexPath) -> UICollectionReusableView {

        guard let cell = collectionView
                .dequeueReusableSupplementaryView(
                    ofKind: kind,
                    withReuseIdentifier: "StarCell",
                    for: indexPath) as? RoundedCollectionViewCell
        else {
            fatalError("Could not cast cell as RoundedCollectionViewCell")
        }

        let star = solarSystem?.star

        let name = star?.name ?? ""
        let age = star?.age ?? 0
        let mass = star?.mass ?? 0

        cell.titleLabel.text = "\(name)"
        cell.secondaryLabel.text = "Age: \(age)\nMass: \(mass)"
        cell.iconImageView.image = UIImage(systemName: "camera.filters")

        return cell
    }
}
