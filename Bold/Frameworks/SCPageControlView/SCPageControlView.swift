//
//  SCPageControlView.swift
//  Pods
//
//  Created by Myoung on 2017. 4. 17..
//
//

import UIKit

@IBDesignable public class SCPageControlView: UIView {
    
    @IBInspectable open var activeWidth: CGFloat = 10 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var elementWidth: CGFloat = 5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var elementHeight: CGFloat = 5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var padding: CGFloat = 5 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var numberOfPages: Int = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var currentOfPage: Int = 0 {
        didSet {
            setNeedsLayout()
        }
    }
    
    @IBInspectable open var activeColor: UIColor = .white {
        didSet {
            setNeedsLayout()
        }
    }
    
    var screenWidth : CGFloat = UIScreen.main.bounds.size.width
    var screenHeight : CGFloat = UIScreen.main.bounds.size.height
    
    public var isCircle: Bool = true
    
    var f_start_point: CGFloat = 0.0, f_start: CGFloat = 0.0
    var f_all_width: CGFloat!
    
    public required init(coder aDecoder: NSCoder) {
        super.init(coder:aDecoder)!
    }
    
    public override init(frame:CGRect) {
        super.init(frame:frame)
    }
    
    public override func layoutSubviews() {
        super.layoutSubviews()
    }
    
    // ## view init method ##
    
    func set_view(_ page: Int, current: Int, current_color: UIColor) {
        
        numberOfPages = page
        currentOfPage = current
        activeColor = current_color
        set_view()
    }
    
    func set_view() {
        
        f_all_width = CGFloat(numberOfPages-1) * elementWidth + CGFloat(numberOfPages-1) * padding + activeWidth - elementWidth
        
        guard f_all_width < self.frame.size.width else {
            print("frame.Width over Number Of Page")
            return
        }
        
        var f_width: CGFloat = elementWidth, f_height: CGFloat = elementHeight
        var f_x: CGFloat = (self.frame.size.width - f_all_width) / 2.0, f_y: CGFloat = (self.frame.size.height - f_height) / 2.0
        
        f_start_point = f_x
        
        for i in 0 ..< numberOfPages {
            let img_page = UIView()
            
            if i == currentOfPage {
                f_width = activeWidth
                img_page.alpha = 1.0
            } else {
                f_width = elementWidth
                img_page.alpha = 0.4
            }
            
            img_page.frame = CGRect(x: f_x, y: f_y, width: f_width, height: f_height)
            img_page.layer.cornerRadius = img_page.frame.size.height/2.0
            img_page.backgroundColor = activeColor
            img_page.tag = i + 10
            self.addSubview(img_page)
            
            f_x += f_width + padding
        }
    }

    // ## return ImageView tag number ##
    func get_imgView_tag(_ f_page: CGFloat) -> Int {
        let f_temp = f_page - 0.02
        return Int(f_temp)
    }
    
    open func scroll_did(_ scrollView: UIScrollView) {
        
        let f_page = scrollView.contentOffset.x / scrollView.frame.size.width
        
        let tag_value = get_imgView_tag(f_page) + 10
        let f_next_start: CGFloat = (CGFloat(tag_value - 10) * scrollView.frame.size.width)
        
        let f_move: CGFloat = ((activeWidth - elementWidth) * (f_start - scrollView.contentOffset.x) / scrollView.frame.size.width)
        let f_alpha: CGFloat = (0.6 * (scrollView.contentOffset.x - f_next_start) / scrollView.frame.size.width)
        
        if let iv_page: UIView = self.viewWithTag(tag_value),
            tag_value >= 10 && tag_value + 1 < 10 + numberOfPages {
            
            iv_page.frame = CGRect(x: f_start_point + ((CGFloat(tag_value) - 10) * (elementWidth + padding)),
                                   y: iv_page.frame.origin.y,
                                   width: activeWidth + (f_move + ((CGFloat(tag_value) - 10) * (activeWidth - elementWidth))),
                                   height: iv_page.frame.size.height)
            iv_page.alpha = 1 - f_alpha
            
            if let iv_page_next: UIView = self.viewWithTag(tag_value + 1) {
                let f_page_next_x: CGFloat = ((f_start_point + padding + activeWidth) + ((CGFloat(tag_value) - 10) * (elementWidth + padding)))
                iv_page_next.frame = CGRect(x: f_page_next_x + (f_move + ((CGFloat(tag_value) - 10) * (activeWidth - elementWidth))),
                                            y: iv_page_next.frame.origin.y,
                                            width: elementWidth - (f_move + ((CGFloat(tag_value) - 10) * (activeWidth - elementWidth))),
                                            height: iv_page_next.frame.size.height)
                iv_page_next.alpha = 0.4 + f_alpha
            }
        }
    }
    
    //MARK: ## View Real size Calculate ##
    func calculateViewRealSize() -> CGRect {
        var viewFrame = self.bounds
        if self.constraints.count != 0 { viewFrame.size.width = screenWidth }
        for element in self.constraints {
            if element.firstAttribute == NSLayoutConstraint.Attribute.height {
                viewFrame.size.height = element.constant
            } else if element.firstAttribute == NSLayoutConstraint.Attribute.width {
                viewFrame.size.width = element.constant
            }
        }
        return viewFrame
    }
}
