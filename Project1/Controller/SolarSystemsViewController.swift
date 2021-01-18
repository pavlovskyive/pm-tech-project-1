//
//  SolarSystemsViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import UIKit

class SolarSystemsViewController: UIViewController {

    var galaxy: Galaxy? {
        didSet {
            title = galaxy?.name
        }
    }
    var timer: RepeatingTimer? {
        didSet {
            timer?.addListener(self)
        }
    }

    var stateMachine: NavigationControllerStateMachine?

    lazy private var collectionView = DoubleColumnCollectionView()

    var timerControl: TimerSegmentedControl?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarController()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        super.viewDidAppear(animated)

        collectionView.reloadData()
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

//    fileprivate func setupTimer() {
//        NotificationCenter.default.addObserver(
//            self, selector: #selector(handleTick),
//            name: Notification.TimerTick, object: nil)
//    }
}

extension SolarSystemsViewController: TimerListener {

    @objc func handleTick() {
        DispatchQueue.main.async {
            if self.view.window != nil {
                self.collectionView.reloadData()
            }
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
        guard let solarSystem = galaxy?.solarSystems[indexPath.row] else { return }
        let solarSystemDetailedState = SolarSystemDetailedState()
        solarSystemDetailedState.solarSystem = solarSystem
        stateMachine?.enter(solarSystemDetailedState)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
