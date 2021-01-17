//
//  SolarSystemDetailedViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import UIKit

class SolarSystemDetailedViewController: UIViewController {

    weak var solarSystem: SolarSystem?
    weak var timer: RepeatingTimer?

    lazy private var collectionView = DoubleColumnCollectionViewWithHeader()

    var timerControl: TimerSegmentedControl?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarController()
        setupCollectionView()
    }
}

extension SolarSystemDetailedViewController {

    fileprivate func setupNavigationBarController() {
        navigationController?.navigationBar.shadowImage = UIImage()

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }

        self.navigationItem.titleView = timerControl

        title = "\(solarSystem?.name ?? "")"
    }

    fileprivate func setupCollectionView() {

        collectionView.dataSource = self

        view.addSubview(collectionView)

        collectionView.translatesAutoresizingMaskIntoConstraints = false
        NSLayoutConstraint.activate([
            collectionView.topAnchor.constraint(equalTo: view.topAnchor),
            collectionView.bottomAnchor.constraint(equalTo: view.bottomAnchor),
            collectionView.leadingAnchor.constraint(equalTo: view.leadingAnchor),
            collectionView.trailingAnchor.constraint(equalTo: view.trailingAnchor)
        ])
    }
}

extension SolarSystemDetailedViewController: TimeHandler {

    @objc func handleTick() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension SolarSystemDetailedViewController {

    @objc func handleEditButton() {
        print("Edit cell")
    }
}

extension SolarSystemDetailedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        solarSystem?.planets.count ?? 0
    }

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

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RoundedCell",
                for: indexPath) as? RoundedCollectionViewCell
        else {
            fatalError("Could not cast cell as RoundedCollectionViewCell")
        }

        cell.editButton.addTarget(
            self,
            action: #selector(handleEditButton),
            for: .touchUpInside)

        let planet = solarSystem?.planets[indexPath.row]

        let name = planet?.name
//        let type = solarSystem?.type.rawValue ?? "Spiral"
        let mass = planet?.mass ?? 0

//        var image: UIImage

//        switch planet?.type {
//        case .spiral:
//            image = UIImage(systemName: "hurricane")!
//        case .elliptical:
//            image = UIImage(systemName: "record.circle")!
//        default:
//            image = UIImage(systemName: "aqi.low")!
//        }

        cell.titleLabel.text = name
        cell.secondaryLabel.text = "Mass: \(mass)"
        cell.iconImageView.image = UIImage(systemName: "camera.filters")
//        cell.iconImageView.image = image

        return cell
    }
}
