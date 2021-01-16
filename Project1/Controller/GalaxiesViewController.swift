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

extension GalaxiesViewController {
    
    fileprivate func setupNavigationBarController() {
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        self.navigationItem.titleView = segmentedControl
        
        title = "\(universe?.name ?? "")"
    }
    
    fileprivate func setupCollectionView() {
        
        collectionView.backgroundColor = .systemBackground
        collectionView.register(RoundedCollectionViewCell.self, forCellWithReuseIdentifier: "RoundedCell")
        collectionView.alwaysBounceVertical = true
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
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension GalaxiesViewController {
    
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

extension GalaxiesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        universe?.galaxies.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RoundedCell",
            for: indexPath) as! RoundedCollectionViewCell
        
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

