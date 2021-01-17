//
//  CollectionViewFlowLayout.swift
//  Project1
//
//  Created by Vsevolod Pavlovskyi on 17.01.2021.
//

import UIKit

class DoubleColumnFlowLayout: UICollectionViewFlowLayout {

    override func prepare() {
        super.prepare()

        scrollDirection = .vertical
        itemSize = CGSize(width: (collectionView!.bounds.width / 2) - 20, height: 140)
        sectionInset = UIEdgeInsets(top: 15, left: 0, bottom: 15, right: 0)
    }
}

final class DoubleColumnFlowLayoutWithHeader: DoubleColumnFlowLayout {
    override func prepare() {
        super.prepare()

        headerReferenceSize = CGSize(width: collectionView!.bounds.width - 20, height: 120)
    }
}
