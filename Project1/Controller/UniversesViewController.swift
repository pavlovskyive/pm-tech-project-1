//
//  UniversesViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 15.01.2021.
//

import UIKit

class UniversesViewController: UIViewController {

    var storage: Storage?
    var timer: RepeatingTimer? {
        didSet {
            timer?.addListener(self)
        }
    }
    var stateMachine: NavigationControllerStateMachine?

    lazy private var collectionView = DoubleColumnCollectionView()

    private var timerControl = TimerSegmentedControl()

    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        title = "Universes"

        setupNavigationBarController()
        setupCollectionView()
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()

        print("Received memory warning")
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

        timerControl.addTarget(self, action: #selector(handleSegmentedControllValueChanged), for: .valueChanged)
        self.navigationItem.titleView = timerControl

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

extension UniversesViewController: TimerListener {
    @objc func handleTick() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension UniversesViewController {

    @objc func handleSegmentedControllValueChanged() {
        switch timerControl.selectedSegmentIndex {
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

    @objc func handleAddButton() {
        let alertController = UIAlertController(
            title: "Universe Creation",
            message: "Enter New Universe Name",
            preferredStyle: .alert)

        alertController.addTextField()

        let submitAction = UIAlertAction(title: "Submit", style: .default) { _ in
            let answer = alertController.textFields![0]
            let text = answer.text ?? ""

//            self.viewModel.createUniverse(
//                name: text,
//                blackHoleThresholdMass: 50,
//                blackHoleThresholdRadius: 50)
            self.storage?.createUniverse(name: text)

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
        storage?.universes.count ?? 0
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

        guard let universe = storage?.universes[indexPath.row] else {
            return cell
        }

        cell.titleLabel.text = universe.name
        cell.secondaryLabel.text = "Age: \(universe.age)"
        cell.iconImageView.image = UIImage(systemName: "camera.filters")

        return cell
    }
}

extension UniversesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        let galaxiesStage = GalaxiesState()
        galaxiesStage.universe = storage?.universes[indexPath.row]
        stateMachine?.enter(galaxiesStage)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}
