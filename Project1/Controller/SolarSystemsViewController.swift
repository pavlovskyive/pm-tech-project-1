//
//  SolarSystemsViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import UIKit

class SolarSystemsViewController: UIViewController {

    weak var galaxy: Galaxy?
    weak var timer: RepeatingTimer?

    lazy private var collectionView = DoubleColumnCollectionView()

    private var solarSystemDetailedViewController: SolarSystemDetailedViewController?

    var timerControl: TimerSegmentedControl?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarController()
        setupCollectionView()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        // Made so we don't update UI of next view controller if it's not on the screen
        solarSystemDetailedViewController = nil
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }
}

extension SolarSystemsViewController {

    fileprivate func setupNavigationBarController() {
        navigationController?.navigationBar.shadowImage = UIImage()

        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }

        self.navigationItem.titleView = timerControl

        title = "\(galaxy?.name ?? "")"
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

extension SolarSystemsViewController: TimeHandler {

    @objc func handleTick() {
        solarSystemDetailedViewController?.handleTick()

        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension SolarSystemsViewController {

    @objc func handleEditButton() {
        print("Edit cell")
    }
}

extension SolarSystemsViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        galaxy?.solarSystems.count ?? 0
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "RoundedCell",
                                     for: indexPath) as? RoundedCollectionViewCell
        else {
            fatalError("Could not cast cell as RoundedCollectionViewCell")
        }

        cell.editButton.addTarget(
            self,
            action: #selector(handleEditButton),
            for: .touchUpInside)

        let solarSystem = galaxy?.solarSystems[indexPath.row]

        let name = solarSystem?.name
        let age = solarSystem?.age ?? 0
//        let type = solarSystem?.type.rawValue ?? "Spiral"
        let mass = solarSystem?.mass ?? 0

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
        cell.secondaryLabel.text = "Age: \(age)\nMass: \(mass)"
        cell.iconImageView.image = UIImage(systemName: "camera.filters")
        cell.iconImageView.image = image

        return cell
    }
}

extension SolarSystemsViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        solarSystemDetailedViewController = SolarSystemDetailedViewController()

        solarSystemDetailedViewController!.timer = timer
        solarSystemDetailedViewController!.timerControl = timerControl
        solarSystemDetailedViewController!.solarSystem = galaxy?.solarSystems[indexPath.row]
        navigationController?.pushViewController(solarSystemDetailedViewController!, animated: true)
    }
}
