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

    override func viewDidLoad() {
        super.viewDidLoad()

        /*
         Mentor's comment:
         It's better to put this expression inside the viewDidAppear method.
         Because viewDidLoad is called only once, but viewDidDisappear may be called several times
         the code may end in an unexpected behavior.
         */
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

        guard let solarSystem = galaxy?.storage.filter({ $0 is SolarSystem })[indexPath.row] as? SolarSystem else {
            return cell
        }

        let name = solarSystem.name
        let starType = solarSystem.star?.type.rawValue ?? ""
        let planetNumber = solarSystem.planets.count

        cell.titleLabel.text = name
        cell.secondaryLabel.text = "Star Type: \(starType)\n" +
            "Number of Planets: \(planetNumber)"
        cell.iconImageView.image = UIImage(systemName: "smallcircle.fill.circle")
        return cell
    }

    private func cellForBlackHole(
        cell: RoundedCollectionViewCell,
        indexPath: IndexPath) -> RoundedCollectionViewCell {

        /*
         Mentor's comment:
         galaxy?.storage.filter({ $0 is Star })[indexPath.row]
         I'd rather put this code into Galaxy. In general it's a good idea not to reach into guts
         of an another class/struct – remember about data/functionality incapsulation to avoid
         "spaghetti code".
         
         By doing so u can transform the code below to something like:
         guard let blackHole = galaxy?.star(at: indexPath.row) else {
             return cell
         }
         */
        guard let blackHole = galaxy?.storage.filter({ $0 is Star })[indexPath.row] as? Star else {
            return cell
        }

        let name = blackHole.name
        let stage = blackHole.stage.rawValue

        cell.titleLabel.text = name
        cell.secondaryLabel.text = "Stage: \(stage)"
        cell.iconImageView.image = UIImage(systemName: "smallcircle.fill.circle.fill")
        return cell
    }

    override func handleCellSelection(indexPath: IndexPath) {

        /*
         Mentor's comment:
         See my comment above.
         
         And there is a bug here 🐞. You're requesting a solar system only by it's row. In case user
         clicks on a blackhole (which is in another section) the code below will handle this event
         as though user clicked on a solar system in the first section.
         */
        guard let solarSystem = galaxy?.storage.filter({ $0 is SolarSystem })[indexPath.row] as? SolarSystem else {
            return
        }

        let solarSystemDetailedViewController = SolarSystemDetailedViewController()
        solarSystemDetailedViewController.solarSystem = solarSystem
        solarSystemDetailedViewController.timer = timer
        navigationController?.pushViewController(solarSystemDetailedViewController, animated: true)
    }
}

extension GalaxyViewController: Alertable {

}

extension GalaxyViewController: GalaxyDelegate {
    func handleDestruction(of galaxy: Galaxy) {
        if galaxy === self.galaxy {
            self.galaxy = nil
            DispatchQueue.main.async { [weak self] in
                /*
                 Mentor's comment:
                 Looks like the timer must be resumed somewhere after suspending it here 🤨
                 */
                self?.timer?.suspend()
                self?.navigationController?.popViewController(animated: true)
                self?.showAlert(title: "Current Galaxy has been destroyed",
                          message: "You've been redirected to previous screen")
            }
        }
    }
}
