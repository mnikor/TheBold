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

//protocol ContentToolBarDelegate: class {
//    func saveContent()
//    func removeFromCache()
//    func likeContent(_ isLiked: Bool)
//    func playerStoped(with totalDuration: TimeInterval)
//    func addActionPlan()
//}

class PlayerViewController: UIViewController, ViewProtocol {
    
    typealias Presenter = PlayerPresenter
    typealias Configurator = PlayerConfigurator
    
    //    weak var delegate: ContentToolBarDelegate?
    
    var presenter: Presenter!
    var configurator: Configurator! = PlayerConfigurator()
    
    var isDownloadedContent: Bool = false
    var contentID: Int?
    var selectedContent: ActivityContent?
    
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
    
    func play() {
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
        if !isDownloadedContent && !buttonsToolbar.dowload {
            isDownloadedContent = !isDownloadedContent
            configureDowloadButton()
            guard let content = selectedContent else { return }
            DataSource.shared.saveContent(content: content)
        }else {
            isDownloadedContent = !isDownloadedContent
            configureDowloadButton()
            guard let content = selectedContent else { return }
            DataSource.shared.deleteContent(content: content)
        }
        
    }
    
    @IBAction func tapLikeButton(_ sender: UIBarButtonItem) {
        buttonsToolbar.like = !buttonsToolbar.like
        likeButton.image = buttonsToolbar.like == false ? Asset.playerLikeIcon.image : Asset.playerLikedIcon.image
        likeButton.tintColor = buttonsToolbar.like == false ? .gray : ColorName.primaryRed.color
        //        delegate?.likeContent(buttonsToolbar.like)
        selectedContent?.likeContent(buttonsToolbar.like)
    }
    
    
    @IBAction func tapShowAddAction(_ sender: UIBarButtonItem) {
        
        guard let selectedContent = selectedContent else {return}
        
        AlertViewService.shared.input(.addAction(content: selectedContent, tapAddPlan: {
            print("tap add action")
        }))
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        configurator.configure(with: self)
        switch AudioService.shared.image {
        case .image(let image):
            if let image = image {
                titleImageView.image = image
            } else {
                titleImageView.image = Asset.playerBackground.image
            }
        case .path(let path):
            setImage(imagePath: path)
        case nil:
            titleImageView.image = Asset.playerBackground.image
        }
        toolBar.setShadowImage(UIImage(), forToolbarPosition: .any)
        addSwipe()
        configureSliderAction()
        AudioService.shared.delegate = self
        if let content = selectedContent {
            isDownloadedContent = DataSource.shared.contains(content: content)
        }
        configureDowloadButton()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        super.viewWillAppear(animated)
        if AudioService.shared.isPlaying() {
            playerIsPlaying()
        }
    }
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
    }
    
    private func configureDowloadButton() {
        buttonsToolbar.dowload = isDownloadedContent
        downloadButton.image = buttonsToolbar.dowload == false ? Asset.playerDownloadIcon.image : Asset.playerDownloadedIcon.image
        downloadButton.tintColor = buttonsToolbar.dowload == false ? .gray : ColorName.primaryBlue.color
    }
    
    func setImage(imagePath: String?) {
        titleImageView.setImageAnimated(path: imagePath ?? "", placeholder: Asset.playerBackground.image)
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
    
    class func createController(content: ActivityContent?) {
        
        guard let content = content else { return }
        
        let playerVC = PlayerViewController.createController()
        playerVC.selectedContent = content
        
        AudioService.shared.config(fullImage: content.imageURL, smallImage: content.smallImageURL, tracks: content.audioTracks)
        AudioService.shared.delegate = playerVC
        AudioService.shared.input(.fullView(activityType: {(activityType) in
            
            switch activityType {
            case .appearing:
                UIApplication.topViewController?.present(playerVC, animated: true) {
                    if content.type != .meditation {
                        playerVC.play()
                    }
                }
            default:
                break
            }
            
        }))
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
        if AudioService.shared.isPlaying() {
            dismiss(animated: true) {
                let smallPlayer = PlayerSmallView()
                smallPlayer.currentContent = self.selectedContent
                AudioService.shared.input(.showSmallPlayer)
            }
        } else {
            AudioService.shared.input(.stop)
            dismiss(animated: true)
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
    
    func playerStoped(with totalDuration: TimeInterval) {
        selectedContent?.playerStoped(with: totalDuration)
    }
    
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
