//
//  PlayerViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak var playerView: UIView!
    @IBOutlet var playerListView: PlayerListView!
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var recommendationLabel: UILabel!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var titleSongLabel: UILabel!
    @IBOutlet weak var subtitleSongLabel: UILabel!
    
    @IBOutlet weak var currentTimeSongLabel: UILabel!
    @IBOutlet weak var durationSongLabel: UILabel!
    @IBOutlet weak var progressView: UIProgressView!
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var downloadButton: UIBarButtonItem!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    
    let service = AudioService()
    
    var buttonsToolbar = StateStatusButtonToolbar()
    
    @IBAction func tapPreviousSong(_ sender: UIButton) {
    }
    
    @IBAction func tapNextSong(_ sender: UIButton) {
    }
    
    @IBAction func tapPlayPause(_ sender: UIButton) {
        
        service.input(.play(audioName: "Bomfunk Mcs - Freestyler.mp3"))
    }
    
    @IBAction func tapShowPlayerList(_ sender: UIBarButtonItem) {
        playerListView.configView(superView: playerView)
    }
    
    @IBAction func tapDownloadButton(_ sender: UIBarButtonItem) {
        buttonsToolbar.dowload = !buttonsToolbar.dowload
        downloadButton.image = buttonsToolbar.dowload == false ? Asset.playerDownloadIcon.image : Asset.playerDownloadedIcon.image
        downloadButton.tintColor = buttonsToolbar.dowload == false ? .gray : ColorName.primaryBlue.color
    }
    
    @IBAction func tapLikeButton(_ sender: UIBarButtonItem) {
        buttonsToolbar.like = !buttonsToolbar.like
        likeButton.image = buttonsToolbar.like == false ? Asset.playerLikeIcon.image : Asset.playerLikedIcon.image
        likeButton.tintColor = buttonsToolbar.like == false ? .gray : ColorName.primaryRed.color
    }
    
    
    @IBAction func tapShowAddAction(_ sender: UIBarButtonItem) {
        performSegue(withIdentifier: StoryboardSegue.Player.playerAddActionPlanIdentifier.rawValue, sender: nil)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        addSwipe()
        
    }
    
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(userSwipe))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
    }
    
    @objc func userSwipe() {
        dismiss(animated: true, completion: nil)
    }
}


struct StateStatusButtonToolbar {
    var dowload: Bool = false
    var like: Bool = false
}
