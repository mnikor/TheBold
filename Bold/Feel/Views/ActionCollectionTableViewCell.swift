//
//  ActionCollectionTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ActionCollectionTableViewCellDelegate: class {
    func tapItemCollection()
}

enum FeelTypeCell {
    case meditation
    case hypnosis
    case pepTalk
    
    func titleText() -> String {
        switch self {
        case .meditation:
            return L10n.Feel.meditation
        case .hypnosis:
            return L10n.Feel.hypnosis
        case .pepTalk:
            return L10n.Feel.pepTalk
        }
    }
    
    func subtitleText() -> String {
        switch self {
        case .meditation:
            return L10n.Feel.meditationSubtitle
        case .hypnosis:
            return L10n.Feel.hypnosisSubtitle
        case .pepTalk:
            return L10n.Feel.pepTalkSubtitle
        }
    }
    
}

class ActionCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: ActionCollectionTableViewCellDelegate?
    var entity: FeelEntity!
    
    @IBAction func tapViewAllButton(_ sender: UIButton) {
        
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        collectionView.register(UINib(nibName: "ActionCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ActionCollectionViewCell")
    }
    
    func config(entity: FeelEntity) {
        
        self.entity = entity
        titleLabel.text = entity.type.titleText()
        subTitleLabel.text = entity.type.subtitleText()
        collectionView.reloadData()
        
    }
    
}

extension ActionCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entity.items.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActionCollectionViewCell", for: indexPath) as! ActionCollectionViewCell
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        delegate?.tapItemCollection()
        print("Select type = \(entity.type), index = \(indexPath.row)")
    }
    
}
