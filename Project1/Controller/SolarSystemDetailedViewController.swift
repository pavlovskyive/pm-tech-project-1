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

    override func viewDidLoad() {
        super.viewDidLoad()

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

        let name = planet.name
        let type = planet.type.rawValue
        let mass = planet.mass
        let numberOfSattelites = planet.sattelites.count

        cell.titleLabel.text = name
        cell.secondaryLabel.text = "Type: \(type)\nMass: \(mass)\nSattelites: \(numberOfSattelites)"
        cell.iconImageView.image = UIImage(systemName: "globe")

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

        let name = star.name
        let type = star.type.rawValue
        let stage = star.stage.rawValue
        let mass = star.mass
        let temperature = star.temperature
        let radius = star.radius
        let luminosity = star.luminosity

        cell.titleLabel.text = "\(name)"
        cell.secondaryLabel.text = "Type: \(type)\n" + "Evolution Stage: \(stage)\n" +
            "Mass: \(mass)    Temperature: \(temperature)\n" +
            "Radius: \(radius)    Luminosity: \(luminosity)"

        cell.iconImageView.image = UIImage(systemName: "staroflife")

        return cell
    }
}

extension SolarSystemDetailedViewController: Alertable {

}

extension SolarSystemDetailedViewController: SolarSystemDelegate {
    func handleDestruction(of solarSystem: SolarSystem) {
        if solarSystem === self.solarSystem {
            self.solarSystem = nil
            DispatchQueue.main.async { [weak self] in
                self?.timer?.suspend()
                self?.navigationController?.popViewController(animated: true)
                self?.showAlert(title: "Current Solar System has been destroyed",
                          message: "You've been redirected to the previous screen")
            }
        }
    }
}
