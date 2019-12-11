//
//  CollectionViewCellAnimator.swift
//  Bold
//
//  Created by Admin on 02.12.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

typealias CollectionViewCellAnimation = (UICollectionViewCell, IndexPath, UICollectionView) -> Void

class CollectionViewCellAnimator {
    private let animation: CollectionViewCellAnimation
    
    init(animation: @escaping CollectionViewCellAnimation) {
        self.animation = animation
    }
    
    func animate(cell: UICollectionViewCell, at indexPath: IndexPath, in collectionView: UICollectionView) {
        animation(cell, indexPath, collectionView)
    }
    
}
