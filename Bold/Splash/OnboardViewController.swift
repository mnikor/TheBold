//
//  OnboardViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 5/28/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import SwiftVideoBackground

let kVideoName = "BackgroundVideo.MOV"

class OnboardViewController: UIViewController {
    
    @IBOutlet weak var pageControl: SCPageControlView!
    @IBOutlet weak var signUpButton: UIButton!
    @IBOutlet weak var findYourBoldnessButton: RoundedButton!
    
    let player = VideoBackground()
    let texts = [OnboardTypeText.feel, OnboardTypeText.think, OnboardTypeText.act]
    
    @IBAction func tapSignUp(_ sender: UIButton) {
        
        
    }
    
    @IBAction func tapFindYourBoldness(_ sender: UIButton) {
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.pageControl.set_view(texts.count, current: 0, current_color: .white)
        setupBackground()
    }
    
    func setupBackground() {
        try? player.play(
            view: self.view,
            videoName: kVideoName.fileName(),
            videoType: kVideoName.fileExtension(),
            isMuted: true,
            darkness: 0,
            willLoopVideo: true,
            setAudioSessionAmbient: false
        )
        
    }
    
    override func viewWillDisappear(_ animated: Bool) {
        super.viewWillDisappear(animated)
        player.pause()
    }
}


extension OnboardViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func numberOfSections(in collectionView: UICollectionView) -> Int {
        return 1
    }
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return texts.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: "onboardCell", for: indexPath) as! OnboardCell
        cell.configure(typeText: texts[indexPath.row])
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        return self.view.bounds.size
    }
    
    func scrollViewDidScroll(_ scrollView: UIScrollView) {
        self.pageControl.scroll_did(scrollView)
    }
    
}
