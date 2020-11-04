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
        guard let fileName = DataSource.shared.searchFile(forKey: name, type: .anim_json)?.path else { return animationContent}
        guard let filePath = animationContent.readFile(name: fileName) else { return animationContent}
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
    
    class func readFile(name: String) -> URL? {
        let file = FileLoader.findFile(name: name)
        return file.first
    }
    
    class func loadAllAnimations() {
//        return
        
//        let dispatchGroup = DispatchGroup()
//        var err : Error?
        
        DispatchQueue.global(qos: .background).async {
            
        NetworkService.shared.loadAnimations { (result) in
            switch result {
            case .failure(let error):
//                err = error
                break
            case .success(let animations):
                
                let saveFiles = DataSource.shared.searchAnimationFiles()
                print("\(saveFiles)")
                
                for animate in animations {
//                    dispatchGroup.enter()
                    
                    let findFiles = saveFiles.filter{ $0.key == animate.key }
                    
                    var animation : (animate: File?, image: File?) = (nil, nil)
                    var isLoad : (animate: Bool, image: Bool) = (false, false)
                    
                    animation.animate = findFiles.filter { $0.type != FileType.anim_image.rawValue }.first
                    animation.image = findFiles.filter { $0.type == FileType.anim_image.rawValue }.first
                    
                    if animation.animate == nil {
                        animation = DataSource.shared.createNewFiles(forAnimation: animate)
                        isLoad = (true, true)
                    }else if animation.animate?.updatedAt != DateFormatter.formatting(type: .contentUpdateAt, dateString: animate.updatedAt) {
                        //search file for key and remove
                        DispatchQueue.main.async {
                            let filesDB = DataSource.shared.searchFiles(forKey: animate.key)
                            for fileDB in filesDB {
                                if let path = fileDB.path, let filePath = AnimationContentView.readFile(name: path) {
                                    try? FileManager.default.removeItem(at: filePath)
                                }
                                DataSource.shared.backgroundContext.delete(fileDB)
                            }
                            DataSource.shared.saveBackgroundContext()
                        }
                        animation = DataSource.shared.createNewFiles(forAnimation: animate)
                        isLoad = (true, true)
                    }else if animation.animate?.isDownloaded == false  || animation.image?.isDownloaded == false {
                        isLoad.animate = animation.animate?.isDownloaded == false
                        isLoad.image = animation.image?.isDownloaded == false
                        }
                    
                    if isLoad.animate {
                        NetworkService.shared.loadFile(with: animate.fileURL, name: animate.key) { (file) in
                            //print("Load File: \n\(file?.url) \n\(file?.path)")
    //                        animate.filePath = file?.path
//                            DispatchQueue.main.async {
                                if let path = file?.url.absoluteString, let animT = DataSource.shared.searchFile(forURL: path) {
                                    animT.path = file?.path.lastPathComponent
                                    animT.isDownloaded = true
                            DataSource.shared.saveBackgroundContext()
                                }
//                            }
    //                        dispatchGroup.leave()
                        }
                    }
                    
                    if let imageURL = animate.imageURL, isLoad.image == true {
//                        dispatchGroup.enter()
                        NetworkService.shared.loadFile(with: imageURL, name: animate.key) { (file) in
                            //print("Load File: \n\(file?.url) \n\(file?.path)")
//                            animate.imagePath = file?.path
//                            DispatchQueue.main.async {
                                if let path = file?.url.absoluteString, let animT = DataSource.shared.searchFile(forURL: path) {
                                animT.path = file?.path.lastPathComponent
                                animT.isDownloaded = true
                                DataSource.shared.saveBackgroundContext()
                                }
//                            }
//                            dispatchGroup.leave()
                        }
                    }
                }
//                print("\(animations)")
            }
        }
        }
//        dispatchGroup.notify(queue: .main) {
//            if let err = err {
//                print("Error = \(err)")
//                return
//            }
//
//            print("All work fine")
//        }
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
