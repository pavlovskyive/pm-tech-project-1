//
//  BaseViewController.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 18.01.2021.
//

import UIKit

class BaseViewController: UIViewController {

    // MARK: - Variables

    // Timer instance
    var timer: RepeatingTimer? {
        didSet {
            timer?.addListener(self)
        }
    }

    // State Machine instance
    var stateMachine: NavigationControllerStateMachine?

    // Timer speed switch
    lazy private var timerControl = TimerSegmentedControl()

    lazy private var collectionView = setCollectionView()

    var backgroundImage: UIImage?

    // MARK: - Lifecycle
    override func viewDidLoad() {
        super.viewDidLoad()
        view.backgroundColor = .systemBackground

        setupNavigationBar()
        setupCollectionView()
    }

    override func viewWillAppear(_ animated: Bool) {
        timerControl.selectedSegmentIndex = timer?.state.rawValue ?? 1
    }

    // MARK: - Setups for override

    func setupNavigationBar() {

        timerControl.addTarget(self, action: #selector(handleSegmentedControllValueChanged), for: .valueChanged)

        navigationItem.titleView = timerControl

        navigationController?.navigationBar.tintColor = .white
        navigationController?.navigationBar.barStyle = .black

        navigationController?.navigationBar.largeTitleTextAttributes =
            [NSAttributedString.Key.foregroundColor: UIColor.white]

        navigationController?.navigationBar.prefersLargeTitles = true
    }

    func setCollectionView() -> DoubleColumnCollectionView {
        return DoubleColumnCollectionView()
    }

    func getCellCount() -> Int {
        fatalError("Must Override")
    }

    func setupCell(cell: RoundedCollectionViewCell, indexPath: IndexPath) -> RoundedCollectionViewCell {
        fatalError("Must Override")
    }

    func handleCellSelection(indexPath: IndexPath) {
        fatalError("Must Override")
    }

    func reloadCollectionView() {
        DispatchQueue.main.async {
            self.collectionView.reloadData()
        }
    }
}

extension BaseViewController {

    // Handle timer speed switch
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
}

// MARK: - Collection View

extension BaseViewController {

    private func setupCollectionView() {

        collectionView.delegate = self
        collectionView.dataSource = self

        let imageView = UIImageView()
        imageView.image = backgroundImage
        imageView.contentMode = .scaleAspectFill

        collectionView.backgroundView = imageView

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

// Collection View Data Source
extension BaseViewController: UICollectionViewDataSource {

    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return getCellCount()
    }

    func collectionView(_ collectionView: UICollectionView,
                        cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {

        guard let cell = collectionView
                .dequeueReusableCell(withReuseIdentifier: "RoundedCell",
                                     for: indexPath) as? RoundedCollectionViewCell
        else {
            fatalError("Could not cast cell as RoundedCollectionViewCell")
        }

        return setupCell(cell: cell, indexPath: indexPath)
    }
}

// Collection View Delegate
extension BaseViewController: UICollectionViewDelegate {

    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        handleCellSelection(indexPath: indexPath)
        collectionView.deselectItem(at: indexPath, animated: true)
    }
}

// MARK: - Timer handler
extension BaseViewController: TimerListener {

    @objc func handleTick() {
        reloadCollectionView()
    }
}
