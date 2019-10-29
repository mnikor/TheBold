//
//  HomeCollectionTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/13/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ActivityCollectionTableViewCellDelegate: class {
    func tapShowAllActivity(type: FeelTypeCell)

    func tapItemCollection(goal: Goal)

    func activityCollectionTableViewCell(_ activityCollectionTableViewCell: ActivityCollectionTableViewCell, didTapAtItem indexPath: IndexPath)

}

class ActivityCollectionTableViewCell: BaseTableViewCell {

    @IBOutlet weak var activityImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var subtitleLabel: UILabel!
    @IBOutlet weak var showAllButton: UIButton!
    @IBOutlet weak var collectionView: UICollectionView!
    @IBOutlet weak var heightCollectionConstraint: NSLayoutConstraint!
    @IBOutlet weak var bottomCollectionConstraint: NSLayoutConstraint!
    
    weak var delegate : ActivityCollectionTableViewCellDelegate?
    //var entity : HomeEntity!
    
    var itemViewModel : ActivityViewModel!
    var dataSource = [ActivityItemsViewModel]()
    
    @IBAction func tapAllActivityButton(_ sender: UIButton) {
        print("Tap Show All Activity")
        delegate?.tapShowAllActivity(type: .meditation)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.selectionStyle = .none
        
        registerXibs()
        configCollectionView()
    }

    private func configCollectionView() {
        collectionView.delegate = self
        collectionView.dataSource = self
        collectionView.contentInset = UIEdgeInsets(top: 0, left: 22, bottom: 0, right: 22)
    }
    
    private func registerXibs() {
        collectionView.registerNib(ActivityCollectionViewCell.self)
        collectionView.registerNib(ActInactiveCollectionViewCell.self)
        collectionView.registerNib(GoalCollectionViewCell.self)
    }
    
//    func configCell(entity: HomeEntity) {
//
//        self.entity = entity
//        bottomCollectionConstraint.constant = entity.type.bottomCellHeight()
//
//        switch entity.type {
//        case .actNotActive :
//            showAllButton.isUserInteractionEnabled = false
//            showAllButton.setTitle(nil, for: .normal)
//            showAllButton.setImage(Asset.plusIcon.image, for: .normal)
//            showAllButton.leftTitleInButton()
//            showAllButton.rightImageInButton()
//        case .actActive :
//            showAllButton.isUserInteractionEnabled = false
//            showAllButton.setTitle(nil, for: .normal)
//            showAllButton.setImage(Asset.plusIcon.image, for: .normal)
//            showAllButton.leftTitleInButton()
//            showAllButton.rightImageInButton()
//        case .activeGoals:
//            showAllButton.isUserInteractionEnabled = true
//            showAllButton.setTitle("Show all", for: .normal)
//            showAllButton.setImage(Asset.rightArrowIcon.image, for: .normal)
//            showAllButton.leftTitleInButton()
//            showAllButton.rightImageInButton()
//        default:
//            showAllButton.isUserInteractionEnabled = true
//            showAllButton.setTitle("Show all", for: .normal)
//            showAllButton.setImage(Asset.rightArrowIcon.image, for: .normal)
//            showAllButton.leftTitleInButton()
//            showAllButton.rightImageInButton()
//        }
//
//        switch entity.type {
//        case .feel:
//            activityImageView.image = Asset.menuFeel.image
//            titleLabel.text = "Feel Bold"
//            subtitleLabel.text = "Rewire your mind"
//        case .think:
//            activityImageView.image = Asset.menuThink.image
//            titleLabel.text = "Think Bold"
//            subtitleLabel.text = "Jump into other bold minds"
//        case .actActive, .actNotActive:
//            activityImageView.image = Asset.menuAct.image
//            titleLabel.text = "Act Bold"
//            subtitleLabel.text = "Take a next step"
//        case .activeGoals:
//            activityImageView.isHidden = true
//            titleLabel.text = "Active goals"
//            subtitleLabel.text = "You have 3 tasks with stakes"
//        default:
//            break
//        }
//
//        collectionView.reloadData()
//    }
    
    func configCell(viewModel: ActivityViewModel) {
        
            activityImageView.isHidden = viewModel.imageIsHidden
            activityImageView.image = viewModel.image
            titleLabel.text = viewModel.title
            subtitleLabel.text = viewModel.subtitle
            showAllButton.isUserInteractionEnabled = viewModel.enabledButton
            showAllButton.setTitle(viewModel.titleButton, for: .normal)
            showAllButton.setImage(viewModel.imageButton, for: .normal)
            showAllButton.leftTitleInButton()
            showAllButton.rightImageInButton()
            //collectionView
            //heightCollectionConstraint.constant =
            //bottomCollectionConstraint.constant =
            
        
        itemViewModel = viewModel
        
            
            dataSource = viewModel.items
        
        collectionView.reloadData()
    }
    
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource

extension ActivityCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return dataSource.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let item = dataSource[indexPath.row]
        
//        switch item.type {
//        case .feel, .think:
//            let cell = collectionView.dequeReusableCell(indexPath: indexPath) as ActivityCollectionViewCell
//            return cell
//        case .actNotActive:
//            let cell = collectionView.dequeReusableCell(indexPath: indexPath) as ActInactiveCollectionViewCell
//            return cell
//        case .actActive, .activeGoals:
//            let cell = collectionView.dequeReusableCell(indexPath: indexPath) as GoalCollectionViewCell
//            //cell.configCell(view: GoalEntity(type: .BuildHouseForParents, active: .locked, progress: 0, total: 0))
//            //cell.configCell(viewModel: <#T##GoalCollectionViewModel#>)
//            return cell
//        default:
//            return UICollectionViewCell()
//        }
        
        switch item {
        case .goal(goal: let goalViewModel):
//=======
//        switch entity.type {
//        case .feel, .think:
//            let cell = collectionView.dequeReusableCell(indexPath: indexPath) as ActivityCollectionViewCell
//            if let type = entity.items?[indexPath.row] as? FeelTypeCell {
//                cell.config(with: type)
//            }
//            return cell
//        case .actNotActive:
//            let cell = collectionView.dequeReusableCell(indexPath: indexPath) as ActInactiveCollectionViewCell
//            return cell
//        case .actActive, .activeGoals:
//>>>>>>> feature/Notifications
            let cell = collectionView.dequeReusableCell(indexPath: indexPath) as GoalCollectionViewCell
            cell.configCell(viewModel: goalViewModel)
            return cell
        default:
            return UICollectionViewCell()
        }
        
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        delegate?.activityCollectionTableViewCell(self, didTapAtItem: indexPath)
        
        let item = dataSource[indexPath.row]
        switch item {
        case .goal(goal: let goalViewModel):
            delegate?.tapItemCollection(goal: goalViewModel.goal)
        default:
            return
        }
        
        //print("Activity type = \(entity.type) index tap = \(indexPath.row)")
    }
    
}

//MARK:- UICollectionViewDelegateFlowLayout

extension ActivityCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        //let item = dataSource[indexPath.row]
        return itemViewModel.collectionCellSize //item.collectionCellSize
        //return entity.type.collectionCellSize()
    }
    
}
