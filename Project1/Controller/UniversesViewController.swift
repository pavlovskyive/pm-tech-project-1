//
//  UniversesViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 15.01.2021.
//

import UIKit

class UniversesViewController: BaseViewController {

    // Link to Storage instance
    var storage: Storage?

    override var backgroundImage: UIImage? {
        get {
            return UIImage(named: "UniversesBackground")
        }
        set {
            super.backgroundImage = newValue
        }
    }

    override func setupNavigationBar() {
        super.setupNavigationBar()

        title = "Universes"

        navigationItem.setRightBarButton(
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(handleAddButton)),
            animated: true)
    }

    override func setupCell(cell: RoundedCollectionViewCell, indexPath: IndexPath) -> RoundedCollectionViewCell {

        guard let universe = storage?.universes[indexPath.row] else {
            return cell
        }

        cell.titleLabel.text = universe.name
        cell.secondaryLabel.text = "Time since creation: \(universe.age)"
        cell.iconImageView.image = UIImage(systemName: "infinity")

        return cell
    }

    override func handleCellSelection(indexPath: IndexPath) {

        guard let universe = storage?.universes[indexPath.row] else {
            return
        }

        let galaxiesViewController = GalaxiesViewController()
        galaxiesViewController.universe = universe
        galaxiesViewController.timer = timer
        navigationController?.pushViewController(galaxiesViewController, animated: true)
    }
}

extension UniversesViewController {

    @objc func handleAddButton() {
        self.storage?.createUniverse()
        super.reloadCollectionView()
    }
}

extension UniversesViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        storage?.universes.count ?? 0
    }
}
