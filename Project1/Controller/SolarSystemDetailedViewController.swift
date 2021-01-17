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
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        segmentedControl.selectedSegmentIndex = timer?.state.rawValue ?? 1
    }
}

extension SolarSystemDetailedViewController {
    
    fileprivate func setupNavigationBarController() {
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        self.navigationItem.titleView = segmentedControl
        
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

extension SolarSystemDetailedViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        solarSystem?.planets.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, viewForSupplementaryElementOfKind kind: String, at indexPath: IndexPath) -> UICollectionReusableView {
        let cell = collectionView.dequeueReusableSupplementaryView(ofKind: kind, withReuseIdentifier: "StarCell", for: indexPath) as! RoundedCollectionViewCell
        
        let star = solarSystem?.star
        
        let name = star?.name ?? ""
        let age = star?.age ?? 0
        let mass = star?.mass ?? 0
        
        cell.titleLabel.text = "\(name)"
        cell.secondaryLabel.text = "Age: \(age)\nMass: \(mass)"
        cell.iconImageView.image = UIImage(systemName: "camera.filters")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RoundedCell",
            for: indexPath) as! RoundedCollectionViewCell
        
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

