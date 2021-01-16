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
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(
            width: (view.frame.width / 2) - 20,
            height: 140)
        
        layout.scrollDirection = .vertical
        
        layout.sectionInset = UIEdgeInsets(
            top: 15,
            left: 15,
            bottom: 15,
            right: 15)
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var solarSystemDetailedViewController: SolarSystemDetailedViewController?
    
    lazy private var segmentedControl: UISegmentedControl = {
        let playImage = UIImage(systemName: "play")!
        let pauseImage = UIImage(systemName: "pause")!
        let maxSpeedImage = UIImage(systemName: "forward")!
        
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: [pauseImage, playImage, maxSpeedImage])
        segmentedControl.sizeToFit()
        segmentedControl.selectedSegmentIndex = timer?.state.rawValue ?? 1
        
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControllValueChanged), for: .valueChanged)
        
        return segmentedControl
    }()
    
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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        segmentedControl.selectedSegmentIndex = timer?.state.rawValue ?? 1
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
        
        self.navigationItem.titleView = segmentedControl
        
        title = "\(galaxy?.name ?? "")"
    }
    
    fileprivate func setupCollectionView() {
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(RoundedCollectionViewCell.self, forCellWithReuseIdentifier: "RoundedCell")
        collectionView.alwaysBounceVertical = true
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
    
    @objc func handleSegmentedControllValueChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            timer?.suspend()
        case 1:
            timer?.resume()
        case 2:
            timer?.faster()
        default:
            break
        }
    }
    
    @objc func handleEditButton() {
        print("Edit cell")
    }
}

extension SolarSystemsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        galaxy?.solarSystems.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RoundedCell",
            for: indexPath) as! RoundedCollectionViewCell
        
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
        solarSystemDetailedViewController!.solarSystem = galaxy?.solarSystems[indexPath.row]
        navigationController?.pushViewController(solarSystemDetailedViewController!, animated: true)
    }
}

extension SolarSystemsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        CGSize(
            width: (view.frame.width / 2) - 20,
            height: 140)
    }
}