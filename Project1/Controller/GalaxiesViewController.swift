//
//  GalaxiesViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import UIKit

class GalaxiesViewController: UIViewController {

    weak var universe: Universe?
    weak var timer: RepeatingTimer?

    lazy private var collectionView = DoubleColumnCollectionView()

    private var solarSystemsViewController: SolarSystemsViewController?

    var timerControl: TimerSegmentedControl?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarController()
        setupCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Made so we don't update UI of next view controller if it's not on the screen
        solarSystemsViewController = nil
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension GalaxiesViewController {

    fileprivate func setupNavigationBarController() {
        navigationController?.navigationBar.shadowImage = UIImage()

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }

        self.navigationItem.titleView = timerControl

        title = "\(universe?.name ?? "")"
    }

    fileprivate func setupCollectionView() {

        collectionView.delegate = self
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

extension GalaxiesViewController: TimeHandler {

    @objc func handleTick() {
        self.solarSystemsViewController?.handleTick()

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension GalaxiesViewController {

    @objc func handleEditButton() {
        print("Edit cell")
    }
}

extension GalaxiesViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        universe?.galaxies.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView
                .dequeueReusableCell(
                    withReuseIdentifier: "RoundedCell",
                    for: indexPath) as? RoundedCollectionViewCell
        else {
            fatalError("Could not cast cell as RoundedCollectionViewCell")
        }

        cell.editButton.addTarget(
            self,
            action: #selector(handleEditButton),
            for: .touchUpInside)

        let galaxy = universe?.galaxies[indexPath.row]

        let name = galaxy?.name
        let age = galaxy?.age ?? 0
        let type = galaxy?.type.rawValue ?? "Spiral"
        let mass = galaxy?.mass ?? 0

        var image: UIImage

        switch galaxy?.type {
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
}

extension GalaxiesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        solarSystemsViewController = SolarSystemsViewController()

        solarSystemsViewController!.timer = timer
        solarSystemsViewController!.timerControl = timerControl
        solarSystemsViewController!.galaxy = universe?.galaxies[indexPath.row]
        navigationController?.pushViewController(solarSystemsViewController!, animated: true)
    }
}
