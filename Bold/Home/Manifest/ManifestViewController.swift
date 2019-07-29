//
//  ManifestViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/19/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import AVFoundation

class ManifestViewController: UIViewController, ViewProtocol {
    
    typealias Presenter = ManifestPresenter
    typealias Configurator = ManifestConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = ManifestConfigurator()
    
    @IBOutlet weak var playerView: UIView!
    @IBOutlet weak var playButton: UIButton!
    
    var player : AVPlayer!
    
    @IBAction func tapPlayButton(_ sender: UIButton) {
//        if player.timeControlStatus == .paused {
//            player.play()
//            UIView.animate(withDuration: 0.5, animations: {
//                self.playButton.alpha = 0
//            }) { (_) in
//                self.playButton.isEnabled = false
//                UIView.animate(withDuration: 0.5, delay: 3, options: .layoutSubviews, animations: {
//                    self.playButton.alpha = 1
//                }, completion: { (_) in
//                    self.playButton.isEnabled = true
//                })
//            }
//        }else {
//            player.pause()
//        }
    }
    
    @IBAction func tapCloseButton(_ sender: UIButton) {
        presenter.input(.tapCloseButton)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        playButton.cornerRadius()
        playButton.positionImageBeforeText(padding: 8)
        playButton.shadow()
        
        configurator.configure(with: self)
        
        presenter.input(.tapPlayVideo(kVideoName))
        
//        let videoURL = URL(fileURLWithPath: Bundle.main.path(forResource: video.fileName(), ofType: video.fileExtension())!)
//        do {
//            player = AVPlayer(url: videoURL)
//            let playerLayer = AVPlayerLayer(player: player)
//            playerLayer.frame = self.playerView.bounds
//            self.playerView.layer.addSublayer(playerLayer)
//        } catch {
//            print("error")
//        }
    }
    
}
