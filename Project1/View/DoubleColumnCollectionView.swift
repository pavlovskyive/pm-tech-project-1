//
//  DoubleColumnCollectionView.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

class DoubleColumnCollectionView: UICollectionView {

    // MARK: - Lifecycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: DoubleColumnFlowLayout())
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    fileprivate func setupCollectionView() {
        backgroundColor = .systemBackground
        register(RoundedCollectionViewCell.self, forCellWithReuseIdentifier: "RoundedCell")
        alwaysBounceVertical = true
        contentInset = UIEdgeInsets(top: 15, left: 15, bottom: 15, right: 15)
    }
}

final class DoubleColumnCollectionViewWithHeader: DoubleColumnCollectionView {

    // MARK: - Lifecycle
    
    override init(frame: CGRect, collectionViewLayout layout: UICollectionViewLayout) {
        super.init(frame: .zero, collectionViewLayout: DoubleColumnFlowLayoutWithHeader())
        
        setupCollectionView()
    }
    
    required init?(coder: NSCoder) {
        fatalError("init(coder:) has not been implemented")
    }
    
    // MARK: - Setup
    
    override func setupCollectionView() {
        super.setupCollectionView()
        
        register(RoundedCollectionViewCell.self, forSupplementaryViewOfKind: UICollectionView.elementKindSectionHeader, withReuseIdentifier: "StarCell")
    }
}
