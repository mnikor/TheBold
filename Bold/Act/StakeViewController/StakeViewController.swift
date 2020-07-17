//
//  StakeViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 8/1/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

protocol StakeViewControllerDelegate: class {
    func confirmStake(stake: Float)
}

class StakeViewController: UIViewController {

    @IBOutlet weak var letsMakeLabel: UILabel!
    @IBOutlet weak var yourStakeLabel: UILabel!
    @IBOutlet weak var costStakeLabel: UILabel!
    @IBOutlet weak var countKarmaLabel: UILabel!
    @IBOutlet weak var shapeKarmaImageView: UIImageView!
    @IBOutlet weak var costSlider: UISlider!
    @IBOutlet var costsButton: [CostButton]!
    @IBOutlet weak var confirmButton: UIButton!
    @IBOutlet weak var bootomTextLabel: UITextView!
    
    weak var delegate: StakeViewControllerDelegate?
    var currentStake: Float = 0
    
    @IBAction func actionCostSlider(_ sender: UISlider) {
        
        let roundValue = Int(sender.value)
        
        switch roundValue {
            case 51, 52: sender.value = 50
            case 53, 54: sender.value = 55
            case 56, 57: sender.value = 55
            case 58, 59: sender.value = 60
            case 61, 62: sender.value = 60
            case 63, 64: sender.value = 65
            case 66, 67: sender.value = 65
            case 68, 69: sender.value = 70
            case 71, 72: sender.value = 70
            case 73, 74: sender.value = 75
            case 76, 77: sender.value = 75
            case 78, 79: sender.value = 80
            case 81, 82: sender.value = 80
            case 83, 84: sender.value = 85
            case 86, 87: sender.value = 85
            case 88, 89: sender.value = 90
            case 91, 92: sender.value = 90
            case 93, 94: sender.value = 95
            case 96, 97: sender.value = 95
            case 98, 99: sender.value = 100
            default: break
        }
        
        costStakeLabel.text = NumberFormatter.stringForCurrency(costSlider.value)
        countKarmaLabel.text = pointsString(cost: costSlider.value)
    }
    
    @IBAction func tapCostButton(_ sender: CostButton) {
        let cost = sender.cost.costValue
        costSlider.value = cost
        countKarmaLabel.text = pointsString(cost: costSlider.value)
        costStakeLabel.text = NumberFormatter.stringForCurrency(cost)
    }
    
    @IBAction func tapConfirmButton(_ sender: UIButton) {
        delegate?.confirmStake(stake: costSlider.value)
        navigationController?.popViewController(animated: true)
    }
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        costStakeLabel.text = NumberFormatter.stringForCurrency(currentStake)
        costSlider.value = currentStake
        countKarmaLabel.text = pointsString(cost: costSlider.value)
        
        configSlider()
        configButtons()
        configTextView()
        localize()
    }
    
    private func pointsString(cost: Float) -> String {
        let alpha = costSlider.value == 0 ? 0 : 1
        return "+\(Int(costSlider.value) + alpha * PointsForAction.congratulationsAction)"
    }
    
    //MARK:- Config
    
    private func localize() {
        navigationItem.title = L10n.Act.stake
        letsMakeLabel.text = L10n.Act.Stake.letsMakeYourChallenging
        yourStakeLabel.text = L10n.Act.Stake.yourStake
        confirmButton.setTitle(L10n.Act.Stake.confirmStake, for: .normal)
    }
    
    private func configSlider() {
        for state: UIControl.State in [.normal, .selected, .application, .reserved] {
            costSlider.setThumbImage(Asset.sliderShadowThumb.image, for: state)
        }
    }
    
    private func configButtons() {
        costsButton.forEach { (button) in
            button.cornerRadius()
            button.borderWidth(color: Color(red: 217/255, green: 219/255, blue: 227/255, alpha: 1))
            button.backgroundColor = .white
        }
    }
    
    private func configTextView() {
        
        let fullString = L10n.Act.Stake.allFundsGoesToGlobalCharityFoundation
//        let linkString = L10n.Act.Stake.gcfCareOrg
        
//        let range = fullString.range(of: linkString)!
        let newString = NSMutableAttributedString(string: fullString)
        
        let fullRange = NSRange(location: 0, length: fullString.count)
//        let linkRange = NSRange(range, in: fullString)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        guard let font = FontFamily.MontserratMedium.regular.font(size: 15) else { return }
//        guard let url = NSURL(string: linkString) else { return }
        
        newString.addAttribute(NSAttributedString.Key.font, value: font, range: fullRange)
        newString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorName.typographyBlack50.color, range: fullRange)
        newString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: fullRange)
//        newString.addAttribute(NSAttributedString.Key.link, value: url, range: linkRange)
//        newString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: linkRange)
        
        bootomTextLabel.attributedText = newString
        bootomTextLabel.delegate = self
        bootomTextLabel.isSelectable = true
        bootomTextLabel.isUserInteractionEnabled = true
    }
}

// MARK:- UITextViewDelegate

extension StakeViewController: UITextViewDelegate {
    
    func textViewShouldBeginEditing(_ textView: UITextView) -> Bool {
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith textAttachment: NSTextAttachment, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("shouldInteractWith textAttachment")
        return false
    }
    
    func textView(_ textView: UITextView, shouldInteractWith URL: URL, in characterRange: NSRange, interaction: UITextItemInteraction) -> Bool {
        print("shouldInteractWith URL")
        return false
    }
}
