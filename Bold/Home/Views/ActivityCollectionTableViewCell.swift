//
//  HomeCollectionTableViewCell.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/13/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol ActivityCollectionTableViewCellDelegate: class {
    func tapShowAllActivity(type: HomeActionsTypeCell?)
    func tapItemCollection(goal: Goal)
    func activityCollectionTableViewCell(_ activityCollectionTableViewCell: ActivityCollectionTableViewCell, didTapAtItem indexPath: IndexPath)
    func tapEmptyGoalsCell(type: ActivityViewModel?)
    func longTap(goal: Goal)
    func tapCreateGoal()
}

extension ActivityCollectionTableViewCellDelegate {
    func longTap(goal: Goal) {}
    func tapCreateGoal() {}
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
    
    var itemViewModel : ActivityViewModel?
    var dataSource = [ActivityItemsViewModel?]()
    
    @IBAction func tapAllActivityButton(_ sender: UIButton) {
        print("Tap Show All Activity")
        delegate?.tapShowAllActivity(type: itemViewModel?.type)
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code

        self.selectionStyle = .none
        
        registerXibs()
        configCollectionView()
        addLongTapRecognizer()
    }

    private func addLongTapRecognizer() {
        let longPress = UILongPressGestureRecognizer(target: self, action: #selector(activeLongPress(gesture:)))
        longPress.minimumPressDuration = 1.0
        longPress.delegate = self
        collectionView.addGestureRecognizer(longPress)
    }
    
    @objc private func activeLongPress(gesture : UILongPressGestureRecognizer!) {
        if gesture.state != .began {
            return
        }
        let p = gesture.location(in: self.collectionView)

        if let indexPath = self.collectionView.indexPathForItem(at: p) {
            let item = dataSource[indexPath.row]
            if case .goal(goal: let goal) = item {
                delegate?.longTap(goal: goal.goal)
            }
        } else {
            print("couldn't find index path")
        }
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
        collectionView.registerNib(CreateGoalCollectionViewCell.self)
    }
    
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
        
        if viewModel.type == .activeGoalsAct {
            dataSource = [nil] + viewModel.items
        }else {
            dataSource = viewModel.items
        }
        
        collectionView.reloadData()
    }
    
}

//MARK:- UICollectionViewDelegate, UICollectionViewDataSource

extension ActivityCollectionTableViewCell: UICollectionViewDelegate, UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        switch itemViewModel?.type {
        case .actActive, .activeGoals, .activeGoalsAct, .actNotActive :
            return dataSource.isEmpty ? 1 : dataSource.count
        default:
            return dataSource.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        if !dataSource.isEmpty {
            let item = dataSource[indexPath.row]
            switch item {
            case .content(content: let content):
                let cell = collectionView.dequeReusableCell(indexPath: indexPath) as ActivityCollectionViewCell
                cell.config(with: content)
                return cell
            case .goal(goal: let goal):
                let cell = collectionView.dequeReusableCell(indexPath: indexPath) as GoalCollectionViewCell
                cell.configCell(viewModel: goal)
                return cell
            default:
                let cell = collectionView.dequeReusableCell(indexPath: indexPath) as CreateGoalCollectionViewCell
                return cell
            }
        } else {
            switch itemViewModel?.type {
            case .actActive, .activeGoals:
                let cell = collectionView.dequeReusableCell(indexPath: indexPath) as ActInactiveCollectionViewCell
                return cell
            case .activeGoalsAct, .actNotActive:
                let cell = collectionView.dequeReusableCell(indexPath: indexPath) as CreateGoalCollectionViewCell
                return cell
            default:
                return UICollectionViewCell()
            }
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {

        delegate?.activityCollectionTableViewCell(self, didTapAtItem: indexPath)
        if !dataSource.isEmpty {
            let item = dataSource[indexPath.row]
            
            if item == nil {
                delegate?.tapEmptyGoalsCell(type: itemViewModel)
                return
            }
            
            switch item {
            case .goal(goal: let goalViewModel):
                delegate?.tapItemCollection(goal: goalViewModel.goal)
            default:
                return
            }
        } else {
            switch itemViewModel?.type {
            case .actActive, .activeGoals, .activeGoalsAct, .actNotActive:
                delegate?.tapEmptyGoalsCell(type: itemViewModel)
            default:
                return
            }
        }
        
        //print("Activity type = \(entity.type) index tap = \(indexPath.row)")
    }
    
}

//MARK:- UICollectionViewDelegateFlowLayout

extension ActivityCollectionTableViewCell: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        if dataSource.isEmpty {
            switch itemViewModel?.type {
                case .actActive, .activeGoals: //, .activeGoalsAct, .actNotActive
                    return CGSize(width: 225, height: 102)
                default:
                    return itemViewModel?.collectionCellSize ?? .zero
            }
        }
        //let item = dataSource[indexPath.row]
        return itemViewModel?.collectionCellSize ?? .zero //item.collectionCellSize
        //return entity.type.collectionCellSize()
    }
    
}
