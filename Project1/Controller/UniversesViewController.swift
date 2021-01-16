//
//  UniversesViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 15.01.2021.
//

import UIKit

class UniversesViewController: UIViewController, UICollectionViewDelegate {
    
    private let viewModel = UniversesViewModel()
    
    lazy private var timer: RepeatingTimer = {
        RepeatingTimer(timeInterval: 1)
    }()
    
    lazy private var collectionView: UICollectionView = {
        let layout = UICollectionViewFlowLayout()
        
        layout.itemSize = CGSize(
            width: (view.frame.width / 2) - 20,
            height: 110)
        
        layout.scrollDirection = .vertical
        
        layout.sectionInset = UIEdgeInsets(
            top: 15,
            left: 15,
            bottom: 15,
            right: 15)
        
        return UICollectionView(frame: .zero, collectionViewLayout: layout)
    }()
    
    private var galaxiesViewController: GalaxiesViewController?
    
    lazy private var segmentedControl: UISegmentedControl = {
        let playImage = UIImage(systemName: "play")!
        let pauseImage = UIImage(systemName: "pause")!
        let maxSpeedImage = UIImage(systemName: "forward")!
        
        let segmentedControl: UISegmentedControl = UISegmentedControl(items: [pauseImage, playImage, maxSpeedImage])
        segmentedControl.sizeToFit()
        segmentedControl.selectedSegmentIndex = 1
        
        segmentedControl.addTarget(self, action: #selector(handleSegmentedControllValueChanged), for: .valueChanged)
        
        return segmentedControl
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground
        
        setupNavigationBarController()
        setupCollectionView()
        setupTimer()
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        // Made so we don't update UI of next view controller if it's not on the screen
        galaxiesViewController = nil
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        
        segmentedControl.selectedSegmentIndex = timer.state.rawValue
    }
    
}

extension UniversesViewController {
    
    fileprivate func setupNavigationBarController() {
        navigationController?.navigationBar.shadowImage = UIImage()
        
        if #available(iOS 11.0, *) {
            self.navigationController?.navigationBar.prefersLargeTitles = true
        }
        
        navigationItem.setRightBarButton(
            UIBarButtonItem(
                barButtonSystemItem: .add,
                target: self,
                action: #selector(handleAddButton)),
            animated: true)
        
        self.navigationItem.titleView = segmentedControl
        
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

    func setupTimer() {
        timer.eventHandler = handleTick
        timer.resume()
    }
}

extension UniversesViewController {
    
    @objc func handleTick() {
        viewModel.handleTick()
        galaxiesViewController?.handleTick()
        
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension UniversesViewController {
    
    @objc func handleSegmentedControllValueChanged() {
        switch segmentedControl.selectedSegmentIndex {
        case 0:
            timer.suspend()
        case 1:
            timer.resume()
        case 2:
            timer.faster()
        default:
            break
        }
    }
    
    @objc func handleAddButton() {
        let alertController = UIAlertController(title: "Universe Creation", message: "Enter New Universe Name", preferredStyle: .alert)
        
        alertController.addTextField()
        
        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            let answer = alertController.textFields![0]
            let text = answer.text ?? ""
            
//            self.viewModel.createUniverse(
//                name: text,
//                blackHoleThresholdMass: 50,
//                blackHoleThresholdRadius: 50)
            self.viewModel.createUniverse(name: text)
            
            self.collectionView.reloadData()
        }
        
        let cancelAction = UIAlertAction(title: "Cancel", style: .cancel)
        
        alertController.addAction(submitAction)
        alertController.addAction(cancelAction)
        alertController.view.layoutIfNeeded()
        
        present(alertController, animated: true)
    }
    
    @objc func handleEditButton() {
        print("Edit cell")
    }
}

extension UniversesViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        viewModel.universes.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeueReusableCell(
            withReuseIdentifier: "RoundedCell",
            for: indexPath) as! RoundedCollectionViewCell
        
        cell.editButton.addTarget(
            self,
            action: #selector(handleEditButton),
            for: .touchUpInside)
        
        cell.titleLabel.text = viewModel.universes[indexPath.row].name
        cell.secondaryLabel.text = "Age: \(viewModel.universes[indexPath.row].age)"
        cell.iconImageView.image = UIImage(systemName: "camera.filters")
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        galaxiesViewController = GalaxiesViewController()
        
        galaxiesViewController!.timer = timer
        galaxiesViewController!.universe = viewModel.universes[indexPath.row]
        navigationController?.pushViewController(galaxiesViewController!, animated: true)
    }
}

//extension UniversesViewController: UICollectionViewDelegateFlowLayout {
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
//        CGSize(width: (view.frame.width / 2) - 20, height: 120)
//    }
//    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
//        UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
//    }
//}
