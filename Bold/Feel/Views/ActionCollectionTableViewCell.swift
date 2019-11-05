//
//  ActionCollectionTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ActionCollectionTableViewCellDelegate: class {
    func actionCollectionTableViewCell(_ actionCollectionTableViewCell: ActionCollectionTableViewCell, didTapAtItem indexPath: IndexPath)
    func tapShowAll(typeCells: FeelTypeCell)
}

enum FeelTypeCell: Int {
    case meditation
    case hypnosis
    case pepTalk
    case stories
    case citate
    case lessons
    
    func categoryName() -> String {
        switch self {
        case .meditation:
            return "Meditations"
        case .hypnosis:
            return "Hypnosis"
        case .pepTalk:
            return "Pep-Talks"
        case .stories:
            return "Stories"
        case .citate:
            return "Thoughts"
        case .lessons:
            return "Lessons"
        }
    }
    
    func categoryImage() -> UIImage? {
        switch self {
        case .meditation:
            return Asset.meditation.image
        case .hypnosis:
            return nil
        case .pepTalk:
            return Asset.peptalks.image
        case .stories:
            return Asset.stories.image
        case .lessons:
            return Asset.lessons.image
        case .citate:
            return nil
        }
    }
    
    func titleText() -> String? {
        switch self {
        case .meditation:
            return L10n.Feel.meditation
        case .hypnosis:
            return L10n.Feel.hypnosis
        case .pepTalk:
            return L10n.Feel.pepTalk
        case .stories:
            return L10n.Think.stories
        case .lessons:
            return L10n.Think.lessons
        case .citate:
            return nil
        }
    }
    
    func subtitleText() -> String? {
        switch self {
        case .meditation:
            return L10n.Feel.meditationSubtitle
        case .hypnosis:
            return L10n.Feel.hypnosisSubtitle
        case .pepTalk:
            return L10n.Feel.pepTalkSubtitle
        case .stories:
            return L10n.Think.storiesSubtitle
        case .lessons:
            return L10n.Think.lessonsSubtitle
        case .citate:
            return nil
        }
    }
    
}

class ActionCollectionTableViewCell: BaseTableViewCell {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subTitleLabel: UILabel!
    @IBOutlet weak var viewAllButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    
    weak var delegate: ActionCollectionTableViewCellDelegate?
    var entity: FeelEntity!
    
    @IBAction func tapViewAllButton(_ sender: UIButton) {
        delegate?.tapShowAll(typeCells: entity.type)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 20, bottom: 0, right: 20)
        
        registerXibs()
    }
    
    func registerXibs() {
        collectionView.registerNib(ActionCollectionViewCell.self)
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
        let cell = collectionView.dequeReusableCell(indexPath: indexPath) as ActionCollectionViewCell
        let item = entity.items[indexPath.row]
        cell.config(model: item)
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        delegate?.actionCollectionTableViewCell(self, didTapAtItem: indexPath)
        print("Select type = \(entity.type), index = \(indexPath.row)")
    }
    
}
