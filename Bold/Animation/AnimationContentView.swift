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
//        guard let filePath = animationContent.readFile(name: name + "_animation") else { return animationContent}
        //let animation = Animation.named("Execution")
        guard let fileName = DataSource.shared.searchFile(forKey: name, type: .anim_json)?.name else { return animationContent}
        guard let filePath = FileLoader.readFile(name: fileName) else { return animationContent}
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
}


extension JSONSerialization {
    
    static func loadJSON(withFilename filename: String) throws -> Any? {
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try Data(contentsOf: fileURL)
            let jsonObject = try JSONSerialization.jsonObject(with: data, options: [.mutableContainers, .mutableLeaves])
            return jsonObject
        }
        return nil
    }
    
    static func save(jsonObject: Any, toFilename filename: String) throws -> Bool{
        let fm = FileManager.default
        let urls = fm.urls(for: .documentDirectory, in: .userDomainMask)
        if let url = urls.first {
            var fileURL = url.appendingPathComponent(filename)
            fileURL = fileURL.appendingPathExtension("json")
            let data = try JSONSerialization.data(withJSONObject: jsonObject, options: [.prettyPrinted])
            try data.write(to: fileURL, options: [.atomicWrite])
            return true
        }
        
        return false
    }
}
