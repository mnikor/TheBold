//
//  YearMonthAlertViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/8/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class YearMonthAlertViewController: UIViewController {

    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var datePicker: MonthYearPickerView!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var bottomContentViewConstraint: NSLayoutConstraint!
    
    var confirmBlock : ((_ date: Date) -> Void)?
    var currentDate: Date!
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        
        confirmBlock?(currentDate)
        hideAnimateView()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        hideAnimateView()
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        titleTextLabel.text = L10n.Act.Date.chooseDate
        
        overlayView.alpha = 0
        bottomContentViewConstraint.constant = -self.contentView.bounds.height
        
        datePicker.dateSelected(currentDate: currentDate) { [unowned self] (selectDate: Date) in
            print("selectDate = \(selectDate)")
            self.currentDate = selectDate
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimateView()
    }
    
    class func createController(currentDate:Date, tapConfirm: @escaping ((_ date: Date) -> Void)) -> YearMonthAlertViewController {
        let dateVC = StoryboardScene.Act.yearMonthAlertViewController.instantiate()
        dateVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dateVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dateVC.confirmBlock = tapConfirm
        dateVC.currentDate = currentDate
        return dateVC
    }
    
    func presentedBy(_ vc: UIViewController) {
        vc.present(self, animated: false, completion: nil)
    }
    
    func showAnimateView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0.13
            self.bottomContentViewConstraint.constant = 0
            self.view.layoutIfNeeded()
        }, completion: nil)
    }
    
    func hideAnimateView() {
        UIView.animate(withDuration: 0.3, animations: {
            self.overlayView.alpha = 0
            self.bottomContentViewConstraint.constant = -self.contentView.bounds.height
            self.view.layoutIfNeeded()
        }, completion: { (_) in
            self.dismiss(animated: false, completion: nil)
        })
    }

}
