//
//  PlayerViewController.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit
import CoreMedia

enum PlayerState {
    case stoped
    case playing
    case paused
}

class PlayerViewController: UIViewController, ViewProtocol {
    
    typealias Presenter = PlayerPresenter
    typealias Configurator = PlayerConfigurator
    
    var presenter: Presenter!
    var configurator: Configurator! = PlayerConfigurator()

    @IBOutlet weak var playerView: UIView!
    @IBOutlet var playerListView: PlayerListView!
    
    @IBOutlet weak var titleImageView: UIImageView!
    @IBOutlet weak var recommendationLabel: UILabel!
    @IBOutlet weak var toolBar: UIToolbar!
    @IBOutlet weak var titleSongLabel: UILabel!
    @IBOutlet weak var subtitleSongLabel: UILabel!
    
    @IBOutlet weak var currentTimeSongLabel: UILabel!
    @IBOutlet weak var durationSongLabel: UILabel!
    @IBOutlet weak var slider: UISlider!
    //    @IBOutlet weak var progressView: UIProgressView!
    
    
    @IBOutlet weak var previousButton: UIButton!
    @IBOutlet weak var nextButton: UIButton!
    @IBOutlet weak var playPauseButton: UIButton!
    
    @IBOutlet weak var downloadButton: UIBarButtonItem!
    @IBOutlet weak var likeButton: UIBarButtonItem!
    
    let service = AudioService.shared
    
    var buttonsToolbar = StateStatusButtonToolbar()
    
    private var timer: Timer?
    private var state: PlayerState = .stoped
    
    @IBAction func tapPreviousSong(_ sender: UIButton) {
        AudioService.shared.input(.playPrevious)
    }
    
    @IBAction func tapNextSong(_ sender: UIButton) {
        AudioService.shared.input(.playNext)
    }
    
    @IBAction func tapPlayPause(_ sender: UIButton) {
        service.delegate = self
        
        switch state {
        case .stoped:
            play()
        case .playing:
            pause()
        case .paused:
            resume()
        }
    }
    
    private func play() {
        state = .playing
        slider.value = 0
        service.input(.play(trackIndex: nil))
    }
    
    private func pause() {
        state = .paused
        service.input(.pause)
    }
    
    private func resume() {
        state = .playing
        service.input(.resume)
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
        let vc = AddActionPlanViewController.createController {
            print("tap add action")
        }
        vc.presentedBy(self)
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        configurator.configure(with: self)
        
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        addSwipe()
        configureSliderAction()
        AudioService.shared.delegate = self
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if !AudioService.shared.isPlaying() {
            play()
        } else {
            playerIsPlaying()
        }
    }
    
    private func configureSliderAction() {
        slider.addTarget(self,
                         action: #selector(sliderDidChangeValue(_:)),
                         for: .touchUpInside)
    }
    
    private func configureSlider() {
        slider.maximumValue = Float(service.getDuration()?.seconds ?? 0)
        slider.minimumValue = 0
        slider.value = Float(service.getCurrentTime().seconds)
    }
    
    class func createController() -> PlayerViewController {
        let addVC = StoryboardScene.Player.initialScene.instantiate()
        addVC.modalPresentationStyle = UIModalPresentationStyle.fullScreen
        addVC.modalTransitionStyle = UIModalTransitionStyle.coverVertical
        return addVC
    }
    
    func present(_ vc: UIViewController) {
        vc.present(self, animated: true, completion: nil)
    }
    
    func addSwipe() {
        let swipe = UISwipeGestureRecognizer(target: self, action: #selector(userSwipe))
        swipe.direction = .down
        self.view.addGestureRecognizer(swipe)
    }
    
    @objc func userSwipe() {
        dismiss(animated: true) {
            AudioService.shared.showSmallPlayer()
        }
    }
    
    private func updateTimer() {
        slider.value = Float(AudioService.shared.getCurrentTime().seconds)
        currentTimeSongLabel.text = getCurrentTimeText()
    }
    
    @objc private func sliderDidChangeValue(_ slider: UISlider) {
        let value = Int(slider.value)
        let time = CMTime(seconds: Double(value), preferredTimescale: 1)
        currentTimeSongLabel.text = formatTimeInterval(Double(value))
        service.input(.seek(to: time))
    }
    
}


extension PlayerViewController: AudioServiceDelegate {
    func playerPaused() {
        timer?.invalidate()
    }
    
    func playerIsPlaying() {
        timer?.invalidate()
        titleSongLabel.text = AudioService.shared.getCurrentTrackName()
        subtitleSongLabel.text = AudioService.shared.getCurrentArtistName()
        durationSongLabel.text = getDurationText()
        currentTimeSongLabel.text = getCurrentTimeText()
        configureSlider()
        timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true) { [weak self] _ in
            self?.updateTimer()
        }

    }
    
    func playerFailed() {
        
    }
    
    private func getCurrentTimeText() -> String {
        return formatTimeInterval(service.getCurrentTime().seconds)
    }
    
    private func getDurationText() -> String? {
        guard let duration = service.getDuration()?.seconds else { return "0:00" }
        return formatTimeInterval(duration)
    }
    
    private func formatTimeInterval(_ timeInterval: TimeInterval) -> String {
        let formatter = DateComponentsFormatter()
        formatter.unitsStyle = .positional
        formatter.allowedUnits = [ .minute, .second ]
        formatter.zeroFormattingBehavior = [ .pad ]
        return formatter.string(from: timeInterval) ?? "0:00"
    }
    
}
