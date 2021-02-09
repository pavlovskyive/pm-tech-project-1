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

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        solarSystem?.addDelegate(delegate: self)
    }

    override func viewDidDisappear(_ animated: Bool) {
        super.viewDidDisappear(animated)

        solarSystem?.removeDelegate(delegate: self)
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        title = "Solar System \(solarSystem?.name ?? "")"
    }

    override func setCollectionView() -> DoubleColumnCollectionView {
        return DoubleColumnCollectionViewWithHeader()
    }

    override func getCellCount(for section: Int) -> Int {
        solarSystem?.planets.count ?? 0
    }

    override func setupCell(cell: RoundedCollectionViewCell, indexPath: IndexPath) -> RoundedCollectionViewCell {

        guard let planet = solarSystem?.planets[indexPath.row] else {
            return cell
        }

        let representation = planet.cellRepresentation

        cell.titleLabel.text = representation.name
        cell.secondaryLabel.text = representation.description
        cell.iconImageView.image = representation.icon

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

        guard let star = solarSystem?.star else {
            return cell
        }

        let representation = star.cellRepresentation

        cell.titleLabel.text = representation.name
        cell.secondaryLabel.text = representation.description
        cell.iconImageView.image = representation.icon

        return cell
    }
}

extension SolarSystemDetailedViewController: SolarSystemDelegate {
    func handleDestruction(of solarSystem: SolarSystem) {
        if solarSystem === self.solarSystem {
            self.solarSystem = nil
            DispatchQueue.main.async { [weak self] in
                self?.timer?.suspend()
                self?.showAlert(
                    title: "Current Solar System has been destroyed",
                    message: "You will be redirected to previous screen") {
                    self?.timer?.resume()
                    self?.navigationController?.popViewController(animated: true)
                }
            }
        }
    }
}
