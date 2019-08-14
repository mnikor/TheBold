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
    var currentStake: Float = 35
    
    @IBAction func actionCostSlider(_ sender: UISlider) {
        costStakeLabel.text = NumberFormatter.stringForCurrency(costSlider.value)
    }
    
    @IBAction func tapCostButton(_ sender: CostButton) {
        let cost = sender.cost.costValue
        costSlider.value = cost
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
        
        configSlider()
        configButtons()
        configTextView()
        localize()
    }
    
    //MARK:- Config
    
    func localize() {
        navigationItem.title = L10n.Act.stake
        letsMakeLabel.text = L10n.Act.Stake.letsMakeYourChallenging
        yourStakeLabel.text = L10n.Act.Stake.yourStake
        confirmButton.setTitle(L10n.Act.Stake.confirmStake, for: .normal)
    }
    
    func configSlider() {
        for state: UIControl.State in [.normal, .selected, .application, .reserved] {
            costSlider.setThumbImage(Asset.sliderShadowThumb.image, for: state)
        }
    }
    
    func configButtons() {
        costsButton.forEach { (button) in
            button.cornerRadius()
            button.borderWidth(color: Color(red: 217/255, green: 219/255, blue: 227/255, alpha: 1))
            button.backgroundColor = .white
        }
    }
    
    func configTextView() {
        
        let fullString = L10n.Act.Stake.allFundsGoesToGlobalCharityFoundation
        let linkString = L10n.Act.Stake.gcfCareOrg
        
        let range = fullString.range(of: linkString)!
        let newString = NSMutableAttributedString(string: fullString)
        
        let fullRange = NSRange(location: 0, length: fullString.count)
        let linkRange = NSRange(range, in: fullString)
        
        let paragraph = NSMutableParagraphStyle()
        paragraph.alignment = .center
        
        guard let font = FontFamily.MontserratMedium.regular.font(size: 15) else { return }
        guard let url = NSURL(string: linkString) else { return }
        
        newString.addAttribute(NSAttributedString.Key.font, value: font, range: fullRange)
        newString.addAttribute(NSAttributedString.Key.foregroundColor, value: ColorName.typographyBlack50.color, range: fullRange)
        newString.addAttribute(NSAttributedString.Key.paragraphStyle, value: paragraph, range: fullRange)
        newString.addAttribute(NSAttributedString.Key.link, value: url, range: linkRange)
        newString.addAttribute(NSAttributedString.Key.underlineStyle, value: NSUnderlineStyle.single.rawValue, range: linkRange)
        
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
