//
//  HomeCollectionTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/13/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ActivityCollectionTableViewCellDelegate: class {
    func tapItemCollection()
}

class ActivityCollectionTableViewCell: UITableViewCell {

    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomCollectionConstraint: NSLayoutConstraint!
    
    weak var delegate : ActivityCollectionTableViewCellDelegate?
    var entity : HomeEntity!
    
    @IBAction func tapAllActivityButton(_ sender: UIButton) {
        print("Tap Show All Activity")
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.selectionStyle = .none
        
        collectionView.register(UINib(nibName: "ActivityCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ActivityCollectionViewCell")
        collectionView.register(UINib(nibName: "ActInactiveCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "ActInactiveCollectionViewCell")
        collectionView.register(UINib(nibName: "GoalCollectionViewCell", bundle: nil), forCellWithReuseIdentifier: "GoalCollectionViewCell")
        
        collectionView.delegate = self
        collectionView.dataSource = self
        
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)

    }

    
    func configCell(entity: HomeEntity) {
        
        self.entity = entity
        bottomCollectionConstraint.constant = entity.type.bottomCellHeight()
        
        switch entity.type {
        case .actNotActive :
            showAllButton.isUserInteractionEnabled = false
            showAllButton.setTitle(nil, for: .normal)
            showAllButton.setImage(Asset.plusIcon.image, for: .normal)
            showAllButton.leftTitleInButton()
            showAllButton.rightImageInButton()
        case .actActive :
            showAllButton.isUserInteractionEnabled = false
            showAllButton.setTitle(nil, for: .normal)
            showAllButton.setImage(Asset.plusIcon.image, for: .normal)
            showAllButton.leftTitleInButton()
            showAllButton.rightImageInButton()
        default:
            showAllButton.isUserInteractionEnabled = true
            showAllButton.setTitle("Show all", for: .normal)
            showAllButton.setImage(Asset.rightArrowIcon.image, for: .normal)
            showAllButton.leftTitleInButton()
            showAllButton.rightImageInButton()
        }
        
        switch entity.type {
        case .feel:
            activityImageView.image = Asset.menuFeel.image
            titleLabel.text = "Feel Bold"
            subtitleLabel.text = "Rewire your mind"
        case .think:
            activityImageView.image = Asset.menuThink.image
            titleLabel.text = "Think Bold"
            subtitleLabel.text = "Jump into other bold minds"
        case .actActive, .actNotActive:
            activityImageView.image = Asset.menuAct.image
            titleLabel.text = "Act Bold"
            subtitleLabel.text = "Take a next step"
        default:
            break
        }
        
        collectionView.reloadData()
    }
    
}

extension ActivityCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return entity.items?.count ?? 0
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        switch entity.type {
        case .feel, .think:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActivityCollectionViewCell", for: indexPath) as! ActivityCollectionViewCell
            return cell
        case .actNotActive:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "ActInactiveCollectionViewCell", for: indexPath) as! ActInactiveCollectionViewCell
            return cell
        case .actActive:
            let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "GoalCollectionViewCell", for: indexPath) as! GoalCollectionViewCell
            cell.configCell()
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        delegate?.tapItemCollection()
        
        print("Activity type = \(entity.type) index tap = \(indexPath.row)")
    }
    
}

extension ActivityCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return entity.type.collectionCellSize()
    }
    
}

extension UIButton {
    
    func rightImageInButton() {
        guard let imageInButton = imageView else {
            return
        }
        imageEdgeInsets = UIEdgeInsets(top: 0, left: bounds.size.width - imageInButton.bounds.size.width, bottom: 0, right: 0)
    }
    
    func leftTitleInButton() {
        guard let _ = titleLabel else {
            return
        }
        imageEdgeInsets = UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
}
