//
//  SolarSystemsViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import UIKit

protocol SolarSystemsViewControllerDelegate: AnyObject {
    func solarSystemsViewController(
        _ solarSystemsViewController: SolarSystemsViewController,
        didSelectSolarSystem selectedSolarSystem: SolarSystem)
}

class SolarSystemsViewController: UIViewController {

    var galaxy: Galaxy?
    let timer: RepeatingTimer
    weak var delegate: SolarSystemsViewControllerDelegate?

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

    init(galaxy: Galaxy, timer: RepeatingTimer) {
        self.galaxy = galaxy
        self.timer = timer
        super.init(nibName: nil, bundle: nil)
        self.title = galaxy.name
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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
        delegate?.solarSystemsViewController(self, didSelectSolarSystem: solarSystem)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
