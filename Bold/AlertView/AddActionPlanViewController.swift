//
//  AddActionPlanViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/4/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class AddActionPlanViewController: UIViewController {

    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var addActionView: UIView!
    @IBOutlet weak var contentView: UIView!
    @IBOutlet weak var addActionButton: RoundedButton!
    @IBOutlet weak var bottomAddActionConstraint: NSLayoutConstraint!
    
    var addActionVC : CreateActionViewController!
    private var contentID : String?
    var content: ActivityContent? {
        willSet(newValue) {
            if let newValueContent = newValue {
                contentID = String(newValueContent.id)
                DataSource.shared.saveContent(content: newValueContent, isHidden: nil)
            }else {
                contentID = nil
            }
        }
    }
    var activeOkButton : (() -> Void)?
    
    var navVC : UINavigationController!
    
    @IBAction func tapAddActionButton(_ sender: UIButton) {
        addActionVC.presenter.input(.saveWithContent(contentId: contentID))
        activeOkButton?()
        hideAnimateView()
    }
    
    class func createController(tapOk: @escaping (() -> Void)) -> AddActionPlanViewController {

        let addVC = StoryboardScene.AlertView.addActionPlanViewController.instantiate()
        addVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addVC.activeOkButton = tapOk
        return addVC
    }
    
    class func createController(content: ActivityContent?, tapOk: @escaping (() -> Void)) -> AddActionPlanViewController {

        let addVC = StoryboardScene.AlertView.addActionPlanViewController.instantiate()
        addVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        addVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        addVC.activeOkButton = tapOk
        addVC.content = content
        return addVC
    }
    
    func presentedBy(_ vc: UIViewController) {
        let navVC = UINavigationController(rootViewController: self)
        navVC.modalPresentationStyle = UIModalPresentationStyle.overFullScreen
        vc.present(navVC, animated: false, completion: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        overlayView.alpha = 0
        bottomAddActionConstraint.constant = -self.addActionView.bounds.height
        
        addSwipe()
        displayContentController()
        
//        if let content = self.content {
//            DataSource.shared.saveContent(content: content, isHidden: true)
//        }
    }
    
    func displayContentController() {
        self.addActionVC = StoryboardScene.Act.createActionViewController.instantiate()
        addActionVC.presenter.baseConfigType = .createNewActionSheet(contentID: contentID)
        
//        //self.storyboard?.instantiateViewController(withIdentifier: "MapViewController") as? MapViewController
//
//         if let addActionVC = self.addActionVC {
//            addActionVC.willMove(toParent: self)
//
//             // Add to containerview
//            self.contentView.addSubview(addActionVC.view)
//            self.addChild(addActionVC)
//            addActionVC.didMove(toParent: self)
//       }
        
        if let addActionVC = addActionVC {
            // call before adding child view controller's view as subview
            addChild(addActionVC)

            addActionVC.view.frame = contentView.bounds
            contentView.addSubview(addActionVC.view)

            // call before adding child view controller's view as subview
            addActionVC.didMove(toParent: self)
        }
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        addActionView.roundCorners(corners: [.topLeft, .topRight], radius: 10)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimateView()
    }
    
    func addSwipe() {
        
        let tap = UITapGestureRecognizer(target: self, action: #selector(actionSwipe))
        tap.numberOfTapsRequired = 1
        tap.numberOfTouchesRequired = 1
        overlayView.addGestureRecognizer(tap)
        
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(actionSwipe))
        swipe.direction = .down
        addActionView.addGestureRecognizer(swipe)
    }

    @objc func actionSwipe() {
        hideAnimateView()
    }

    func showAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0.13
            self.bottomAddActionConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideAnimateView() {
        UIView.animate(withDuration: 0.5, animations: {
            self.overlayView.alpha = 0
            self.bottomAddActionConstraint.constant = -self.addActionView.bounds.height
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            //self.dismiss(animated: false, completion: nil)
            self.navigationController?.view.removeFromSuperview()
            self.navigationController?.removeFromParent()
        })
    }
    
}

