//
//  DateAlertViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 7/26/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum DateAlertType {
    case startDate
    case endDate
    
    var titleText : String {
        switch self {
        case .startDate:
            return L10n.Act.Date.chooseStartDate
        case .endDate:
            return L10n.Act.Date.chooseEndDate
        }
    }
}

class DateAlertViewController: UIViewController {

    @IBOutlet weak var overlayView: UIView!
    @IBOutlet weak var contentView: UIView!
    
    @IBOutlet weak var titleTextLabel: UILabel!
    @IBOutlet weak var datePicker: UIDatePicker!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var cancelButton: UIButton!
    
    @IBOutlet weak var bottomContentViewConstraint: NSLayoutConstraint!
    
    var confirmBlock : ((_ date: Date) -> Void)?
    var selectDate: Date!
    var dateType: DateAlertType!
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        
        confirmBlock?(selectDate)
        hideAnimateView()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        hideAnimateView()
    }
    
    @IBAction func selectValueDatePicker(_ sender: UIDatePicker) {
        
        let dateFormatter: DateFormatter = DateFormatter()
        dateFormatter.dateFormat = "MM/dd/yyyy hh:mm a"
        let selectedDate: String = dateFormatter.string(from: sender.date)
        print("Selected value \(selectedDate)")
        selectDate = sender.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextLabel.text = dateType.titleText
        overlayView.alpha = 0
        bottomContentViewConstraint.constant = -self.contentView.bounds.height
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimateView()
    }
    
    class func createController(type:DateAlertType, currentDate:Date?, tapConfirm: @escaping ((_ date: Date) -> Void)) -> DateAlertViewController {
        let dateVC = StoryboardScene.Act.dateAlertViewController.instantiate()
        dateVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dateVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dateVC.confirmBlock = tapConfirm
        dateVC.dateType = type
        dateVC.selectDate = currentDate ?? Date()
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
