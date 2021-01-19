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
        cell.secondaryLabel.text = "\(universe.age)"
        cell.iconImageView.image = UIImage(systemName: "camera.filters")

        return cell
    }

    override func handleCellSelection(indexPath: IndexPath) {
        let galaxiesStage = GalaxiesState()
        galaxiesStage.universe = storage?.universes[indexPath.row]
        stateMachine?.enter(galaxiesStage)
    }
}

extension UniversesViewController {

    @objc func handleAddButton() {
        let alertController = UIAlertController(
            title: "Universe Creation",
            message: "Enter New Universe Name",
            preferredStyle: .alert)

        alertController.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            let answer = alertController.textFields![0]
            let text = answer.text ?? ""

            self.storage?.createUniverse(name: text)

            super.reloadCollectionView()
        }

        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)

        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        alertController.view.layoutIfNeeded()

        present(alertController, animated: true)
    }
}

extension UniversesViewController {

    override func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        storage?.universes.count ?? 0
    }
}
