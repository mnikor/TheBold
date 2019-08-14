//
//  AllGoalsViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/19/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum GoalType {
    case launchStartUp
    case Community
    case Marathon
    case BuildHouseForParents
}

private struct Constants {
    struct SizeCell {
        static let height : CGFloat = 181
    }
    struct Insets {
        static let topCell : CGFloat = 30
        static let rightLeftIndentCell : CGFloat = 20
    }
    struct Spacing {
        static let betweenHorizCell : CGFloat = 12
        static let betweenVertCell: CGFloat = 25
    }
}

class AllGoalsViewController: UIViewController, ViewProtocol {
    
    @IBOutlet weak var collectionView: UICollectionView!
    
    typealias Presenter = AllGoalsPresenter
    typealias Configurator = AllGoalsConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = AllGoalsConfigurator()
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        configNavigationController()
        registerXibs()
    }
    
    func registerXibs() {
        collectionView.registerNib(GoalCollectionViewCell.self)
    }
    
    func configNavigationController() {
        
        self.navigationController?.navigationBar.shadowImage = UIImage()
        navigationController?.navigationBar.isHidden = false
        navigationItem.title = L10n.Act.allGoals
        navigationItem.rightBarButtonItem = UIBarButtonItem(image: Asset.plusTodayActions.image, style: .plain, target: self, action: #selector(tapCreateAction))
    }
    
    @objc func tapCreateAction() {
        print("tapCreateAction")
        presenter.input(.addGoal)
    }
    
    
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if let vc = segue.destination as? CalendarActionsListViewController {
            guard let selectGoal = sender as? GoalEntity else {
                return
            }
            vc.currentGoal = selectGoal
        }
    }
    
}


    // MARK: - UICollectionViewDataSource

extension AllGoalsViewController: UICollectionViewDataSource {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return presenter.goalItems.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        
        let cell = collectionView.dequeReusableCell(indexPath: indexPath) as GoalCollectionViewCell
        cell.configCell(type: presenter.goalItems[indexPath.row])
        return cell
    }
    
}


    // MARK: - UICollectionViewDelegate

extension AllGoalsViewController: UICollectionViewDelegate {
    
    func collectionView(_ collectionView: UICollectionView, didSelectItemAt indexPath: IndexPath) {
        collectionView.deselectItem(at: indexPath, animated: false)
        presenter.input(.selectdItem(presenter.goalItems[indexPath.row]))
    }
    
}


    // MARK: - UICollectionViewDelegateFlowLayout

extension AllGoalsViewController: UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return CGSize(width: self.collectionView.bounds.size.width / 2 - Constants.Insets.rightLeftIndentCell - Constants.Spacing.betweenHorizCell / 2 , height: Constants.SizeCell.height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: Constants.Insets.topCell, left: Constants.Insets.rightLeftIndentCell, bottom: 0, right: Constants.Insets.rightLeftIndentCell)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Spacing.betweenVertCell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        return Constants.Spacing.betweenHorizCell
    }
}
