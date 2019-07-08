//
//  LoginViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/5/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

enum ScrollDirection: Int {
    case none
    case up
    case down
}

class LoginViewController: UIViewController {

    var signUpView: SignUpView!
    var logInView: SignUpView!
    var headerButton: UIButton!
    var bottomView: UIView!
    
    var lastContentOffset : CGFloat = 0
    var scrollDirection = ScrollDirection.up
    
    var typeAuth: TypeAuthView! = .signUp
    var switchAuth: Bool = false
    
    @IBOutlet weak var scrollView: UIScrollView!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.cofigureView()
    }
    
    func cofigureView(){
        
        headerButton = UIButton(frame: .zero)
        headerButton.backgroundColor = .clear
        headerButton.setTitle("", for: .normal)
        scrollView.addSubview(headerButton)
        headerButton.translatesAutoresizingMaskIntoConstraints = false
        
        NSLayoutConstraint.activate([
            headerButton.topAnchor.constraint(equalTo: scrollView.topAnchor),
            headerButton.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            headerButton.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            headerButton.heightAnchor.constraint(equalTo: self.view.heightAnchor),
            headerButton.widthAnchor.constraint(equalTo: self.view.widthAnchor)
            ])
        
        logInView = SignUpView.loadViewFromNib()
        logInView.delegate = self
        logInView.config(typeView: typeAuth, superView: self.scrollView)
        logInView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(logInView)
        
        NSLayoutConstraint.activate([
            logInView.topAnchor.constraint(equalTo: headerButton.bottomAnchor),
            logInView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            logInView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            logInView.widthAnchor.constraint(equalTo: self.view.widthAnchor)
            ])

        bottomView = UIView(frame: .zero)
        bottomView.backgroundColor = logInView.backgroundColor
        bottomView.translatesAutoresizingMaskIntoConstraints = false
        scrollView.addSubview(bottomView)
        
        NSLayoutConstraint.activate([
            bottomView.topAnchor.constraint(equalTo: logInView.bottomAnchor),
            bottomView.leftAnchor.constraint(equalTo: scrollView.leftAnchor),
            bottomView.rightAnchor.constraint(equalTo: scrollView.rightAnchor),
            bottomView.widthAnchor.constraint(equalTo: self.view.widthAnchor),
            bottomView.heightAnchor.constraint(equalToConstant: 100),
            bottomView.bottomAnchor.constraint(equalTo: scrollView.bottomAnchor)
            ])
        
        scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: headerButton.bounds.height + logInView.bounds.height + bottomView.bounds.height)
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        
        self.scrollView.layoutIfNeeded()
        calculatePosition(scrollView: scrollView)
    }
}

extension LoginViewController: SignUpViewDelegate {
    func tapForgot() {
        performSegue(withIdentifier: StoryboardSegue.Auth.forgotPassword.rawValue, sender: nil)
    }
    
    func tapSignUp() {
        print("tap Sign Up")
    }
    
    func tapLogIn() {
        print("tap Log In")
    }
    
    func tapFacebook() {
        print("Facebook")
    }
    
    func tapShowSignUp() {
        scrollDirection = .down
        calculatePosition(scrollView: scrollView)
        switchAuth = true
        typeAuth = .signUp
    }
    
    func tapShowLogIn() {
        scrollDirection = .down
        calculatePosition(scrollView: scrollView)
        switchAuth = true
        typeAuth = .logIn
    }
}

extension LoginViewController: UIScrollViewDelegate {
    
    func calculatePosition(scrollView: UIScrollView) {
        
        let delta : CGFloat = 250
        switch scrollDirection {
        case .up:
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height - scrollView.frame.size.height - 100), animated: true)
            lastContentOffset = scrollView.contentSize.height - scrollView.frame.size.height - delta
        case .down:
            scrollView.setContentOffset(CGPoint(x: scrollView.contentOffset.x, y: 0), animated: true)
            lastContentOffset = 0 + delta
        default:
            break
        }
    }
    
    func scrollViewWillEndDragging(_ scrollView: UIScrollView, withVelocity velocity: CGPoint, targetContentOffset: UnsafeMutablePointer<CGPoint>) {
        if velocity.y != 0 {return}
        if lastContentOffset > scrollView.contentOffset.y {
            scrollDirection = .down
        }else if lastContentOffset < scrollView.contentOffset.y {
            scrollDirection = .up
        }
        calculatePosition(scrollView: scrollView)
    }
    
    func scrollViewWillBeginDecelerating(_ scrollView: UIScrollView) {
        
        let yVelocity =  scrollView.panGestureRecognizer.velocity(in: scrollView).y
        if yVelocity < 0 {
            scrollDirection = .up
        }else if yVelocity > 0 {
            scrollDirection = .down
        }
        calculatePosition(scrollView: scrollView)
    }
    
    func scrollViewDidEndScrollingAnimation(_ scrollView: UIScrollView) {
        if scrollView.contentOffset.y == 0 {
            if switchAuth == true {
                logInView.config(typeView: typeAuth, superView: scrollView)
                self.scrollView.layoutIfNeeded()
                scrollView.contentSize = CGSize(width: self.view.bounds.size.width, height: headerButton.bounds.height + logInView.bounds.height + bottomView.bounds.height)
                scrollDirection = .up
                calculatePosition(scrollView: scrollView)
                switchAuth = false
            }else {
                self.dismiss(animated: true, completion: nil)
            }
        }
    }
    
    
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        
        if scrollView.contentOffset.y >= scrollView.contentSize.height - scrollView.frame.size.height - 50 {
            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: scrollView.contentSize.height - scrollView.frame.size.height - 50)
        }
        //        if scrollView.contentOffset.y <= 50 {
        //            scrollView.contentOffset = CGPoint(x: scrollView.contentOffset.x, y: 50)
        //        }
    }
    
}
