//
//  AnimationContent.swift
//  Bold
//
//  Created by Alexander Kovalov on 06.10.2020.
//  Copyright © 2020 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit
import Lottie

class AnimationContentView {
    
    private let animationView = AnimationView()
    private var delay : Int = 0
    
    class func setupAnimation(view: UIView, name: String, delay: Int? = nil) -> AnimationContentView {
        
        let animationContent = AnimationContentView()
        guard let filePath = animationContent.readFile(name: name + ".json") else { return animationContent}
        //let animation = Animation.named("Execution")
        let animation = Animation.filepath(filePath.path)
        animationContent.animationView.animation = animation
        animationContent.animationView.contentMode = .scaleToFill
        animationContent.animationView.fixInView(view)
        view.layer.masksToBounds = true
        
        if let delay = delay {
            animationContent.delay = delay
        }
        
        return animationContent
    }
    
    func play() {
        DispatchQueue.main.async {
            self.animationView.play(fromProgress: 0,
                                    toProgress: 1,
                                    loopMode: self.delay == 0 ? LottieLoopMode.loop : LottieLoopMode.playOnce,
                                    completion: { (finished) in
                                        if finished {
                                            print("Animation Complete")
                                        } else {
                                            print("Animation cancelled")
                                        }
                                        
                                        if self.delay != 0 {
                                            DispatchQueue.main.asyncAfter(deadline: .now() + DispatchTimeInterval.seconds(self.delay)) {
                                                self.play()
                                            }
                                        }
                                    })
        }
    }
    
    func stop() {
        DispatchQueue.main.async { [weak self] in
            self?.animationView.stop()
        }
    }
    
    private func readFile(name: String) -> URL? {
        let file = FileLoader.findFile(name: name)
        return file.first
    }
    
    class func loadAllAnimations() {
        
        let dispatchGroup = DispatchGroup()
        var err : Error?
        
        NetworkService.shared.loadAnimations { (result) in
            switch result {
            case .failure(let error):
                err = error
            case .success(let animations):
                for animate in animations {
                    dispatchGroup.enter()
                    NetworkService.shared.loadFile(with: animate.fileURL, name: animate.key) { (file) in
                        dispatchGroup.leave()
                        print("Load File: \n\(file?.url) \n\(file?.path)")
                    }
                }
            }
        }
        
        dispatchGroup.notify(queue: .main) {
            if let err = err {
                print("Error = \(err)")
                return
            }
            
            print("All work fine")
        }
    }
    
}
