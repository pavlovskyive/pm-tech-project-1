//
//  GalaxiesViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 16.01.2021.
//

import UIKit

protocol GalaxiesViewControllerDelegate: AnyObject {
    func galaxiesViewController(
        _ galaxiesViewController: GalaxiesViewController,
        didSelectGalaxy selectedGalaxy: Galaxy)
}

class GalaxiesViewController: UIViewController {

    var universe: Universe?
    let timer: RepeatingTimer
    weak var delegate: GalaxiesViewControllerDelegate?

    lazy private var collectionView = DoubleColumnCollectionView()

    var timerControl: TimerSegmentedControl?

    override func viewDidLoad() {
        super.viewDidLoad()

        setupNavigationBarController()
        setupCollectionView()
        setupTimer()
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        collectionView.collectionViewLayout.invalidateLayout()
    }

    init(universe: Universe, timer: RepeatingTimer, title: String) {
        self.universe = universe
        self.timer = timer
        super.init(nibName: nil, bundle: nil)
        self.title = title
    }

    required init?(coder aDecoder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
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

    fileprivate func setupTimer() {
        NotificationCenter.default.addObserver(
            self, selector: #selector(handleTick),
            name: Notification.TimerTick, object: nil)
    }
}

extension GalaxiesViewController: TimeHandler {

    @objc func handleTick() {
        DispatchQueue.main.async {
            if self.view.window != nil {
                self.collectionView.reloadData()
            }
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
        guard let galaxy = universe?.galaxies[indexPath.row] else { return }
        delegate?.galaxiesViewController(self, didSelectGalaxy: galaxy)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
