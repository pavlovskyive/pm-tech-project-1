//
//  UniversesViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 15.01.2021.
//

import UIKit

class UniversesViewController: UIViewController {

    private let appModel = AppModel()

    lazy private var timer: RepeatingTimer = {
        RepeatingTimer(timeInterval: 1)
    }()

    lazy private var collectionView = DoubleColumnCollectionView()

    private var galaxiesViewController: GalaxiesViewController?

    private var timerControl = TimerSegmentedControl()

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

    func setupTimer() {
        timer.eventHandler = handleTick
        timer.resume()
    }
}

extension UniversesViewController {

    @objc func handleTick() {
        appModel.handleTick()
        galaxiesViewController?.handleTick()

        DispatchQueue.main.async {
            if self.view.window != nil {
                self.collectionView.reloadData()
            }
        }
    }
}

extension UniversesViewController {

    @objc func handleSegmentedControllValueChanged() {
        switch timerControl.selectedSegmentIndex {
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
            self.appModel.createUniverse(name: text)

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
        appModel.universes.count
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

        cell.titleLabel.text = appModel.universes[indexPath.row].name
        cell.secondaryLabel.text = "Age: \(appModel.universes[indexPath.row].age)"
        cell.iconImageView.image = UIImage(systemName: "camera.filters")

        return cell
    }
}

extension UniversesViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        galaxiesViewController = GalaxiesViewController()

        galaxiesViewController!.timer = timer
        galaxiesViewController!.timerControl = timerControl
        galaxiesViewController!.universe = appModel.universes[indexPath.row]
        navigationController?.pushViewController(galaxiesViewController!, animated: true)
    }
}
