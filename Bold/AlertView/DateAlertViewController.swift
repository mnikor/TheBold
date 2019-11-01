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
    case time
    
    var titleText : String {
        switch self {
        case .startDate:
            return L10n.Act.Date.chooseStartDate
        case .endDate:
            return L10n.Act.Date.chooseEndDate
        case .time:
            return "Choose time"
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
    var periodDate: RangeDatePeriod!
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        
        confirmBlock?(selectDate)
        hideAnimateView()
    }
    
    @IBAction func tapCancelButton(_ sender: UIButton) {
        hideAnimateView()
    }
    
    @IBAction func selectValueDatePicker(_ sender: UIDatePicker) {
        
        print("Selected value \(DateFormatter.formatting(type: .startOrEndDate, date: sender.date))")
        selectDate = sender.date
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        titleTextLabel.text = dateType.titleText
        datePicker.date = selectDate
        datePicker.datePickerMode = dateType == .time ? .time : .date
        
        overlayView.alpha = 0
        bottomContentViewConstraint.constant = -self.contentView.bounds.height
        
        if (periodDate != nil) {
            datePicker.minimumDate = periodDate.start
            datePicker.maximumDate = periodDate.end
        }
    }

    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        showAnimateView()
    }
    
    class func createController(type:DateAlertType, currentDate:Date?, startDate: Date?, endDate:Date?, tapConfirm: @escaping ((_ date: Date) -> Void)) -> DateAlertViewController {
        let dateVC = StoryboardScene.AlertView.dateAlertViewController.instantiate()
        dateVC.modalPresentationStyle = UIModalPresentationStyle.overCurrentContext
        dateVC.modalTransitionStyle = UIModalTransitionStyle.crossDissolve
        dateVC.confirmBlock = tapConfirm
        dateVC.dateType = type
        
        if type != .time, let startDateTemp = startDate, let endDateTemp = endDate {
            dateVC.periodDate = RangeDatePeriod(start: startDateTemp, end: endDateTemp)
        }
        
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
            //self.dismiss(animated: false, completion: nil)
            self.view.removeFromSuperview()
            self.removeFromParent()
        })
    }
    
}
