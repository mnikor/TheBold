//
//  FileLoader.swift
//  Bold
//
//  Created by Admin on 21.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation
import UIKit

class FileLoader: NSObject {
    let downloadCompletion: (((path: URL, url: URL)?) -> Void)
    private var nameFile: String?
    
    lazy var backgroundSession : URLSession = {
        let config = URLSessionConfiguration.background(withIdentifier: "com.bold.backgroundSession")
        config.sessionSendsLaunchEvents = true
        config.allowsCellularAccess = true
        let urlSession = URLSession(configuration: config, delegate: self, delegateQueue: nil)
        return urlSession
    }()
    
    init(downloadCompletion: @escaping (((path: URL, url: URL)?) -> Void)) {
        self.downloadCompletion = downloadCompletion
    }
    
    func load(from url: String, nameFile: String? = nil) {
        guard let url = URL(string: url) else { return }
        self.nameFile = nameFile
//        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = backgroundSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
    //MARK:- Loader
    
    class func loadAllAnimations() {
        
        DispatchQueue.global(qos: .background).async {
            
            NetworkService.shared.loadAnimations { (result) in
                switch result {
                case .failure(_):
                    break
                case .success(let animations):
                    
                    let saveFiles = DataSource.shared.searchAnimationFiles()
                    
                    for animate in animations {
                        
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
                            let filesDB = DataSource.shared.searchFiles(forKey: animate.key)
                            for fileDB in filesDB {
                                if let path = fileDB.path { //, let filePath = AnimationContentView.readFile(name: path) {
                                    try? FileManager.default.removeItem(atPath: path) //(at: filePath)
                                }
                                DataSource.shared.backgroundContext.delete(fileDB)
                            }
                            DataSource.shared.saveBackgroundContext()
                            
                            animation = DataSource.shared.createNewFiles(forAnimation: animate)
                            isLoad = (true, true)
                            
                        }else if animation.animate?.isDownloaded == false  || animation.image?.isDownloaded == false {
                            
                            isLoad.animate = animation.animate?.isDownloaded == false
                            isLoad.image = animation.image?.isDownloaded == false
                        }
                        
                        if isLoad.animate {
                            FileLoader.downloadFile(with: animate.fileURL, animateKey: animate.key)
                        }
                        
                        if let imageURL = animate.imageURL, isLoad.image == true {
                            FileLoader.downloadFile(with: imageURL, animateKey: animate.key)
                        }
                    }
                }
            }
        }
    }
    
    class func downloadFile(with fileURL: String?, animateKey: String) {
        NetworkService.shared.loadFile(with: fileURL, name: animateKey) { (file) in
            //                            DispatchQueue.main.async {
            if let path = file?.url.absoluteString, let animT = DataSource.shared.searchFile(forURL: path) {
                animT.name = file?.path.lastPathComponent
                animT.path = file?.path.path
                animT.isDownloaded = true
                DataSource.shared.saveBackgroundContext()
            }
            //                            }
        }
    }
    
    class func findFile(name: String) -> [URL] {

        let downloadsPath = NSSearchPathForDirectoriesInDomains(.documentDirectory, .userDomainMask, true)[0]
        let docURL = URL(string: downloadsPath)!
        let boldDirectory = docURL.appendingPathComponent("Bold")

//        let url =  NSURL(fileURLWithPath: boldDirectory.absoluteString)
//        if let pathComponent = url.appendingPathComponent(name) {
//            let filePath = pathComponent.path
//            let fileManager = FileManager.default
//            if fileManager.fileExists(atPath: filePath) {
//                print("FILE AVAILABLE")
//                //return filePath
//            } else {
//                print("FILE NOT AVAILABLE")
//                //return nil
//            }
//        } else {
//            print("FILE PATH NOT AVAILABLE")
//            //return nil
//        }

        var files = [URL]()
        if let enumerator = FileManager.default.enumerator(at: boldDirectory, includingPropertiesForKeys: [.isRegularFileKey], options: [.skipsHiddenFiles, .skipsPackageDescendants]) {
            for case let fileURL as URL in enumerator {
                do {
                    let fileAttributes = try fileURL.resourceValues(forKeys:[.isRegularFileKey])
                    if fileAttributes.isRegularFile! {
                        if fileURL.lastPathComponent.lowercased().contains(name.lowercased())  {
                            files.append(fileURL)
                        }
                        //files.append(fileURL)
                    }
                } catch { print(error, fileURL) }
            }
            print(files)
        }
        return files
    }
    
    class func readFile(name: String) -> URL? {
        let file = FileLoader.findFile(name: name)
        return file.first
    }
}

extension FileLoader: URLSessionDownloadDelegate {
    
    func urlSessionDidFinishEvents(forBackgroundURLSession session: URLSession) {
        print("forBackgroundURLSession")
        
        DispatchQueue.main.async {
            if let appDelegate = UIApplication.shared.delegate as? AppDelegate,
               let completionHandler = appDelegate.backgroundSessionCompletionHandler {
                appDelegate.backgroundSessionCompletionHandler = nil
                
                completionHandler()
            }
        }
    }
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        
        guard let url = downloadTask.originalRequest?.url else { return }
        let downloadsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let boldDirectory = downloadsPath.appendingPathComponent("Bold")
        let ext = String(url.lastPathComponent.split(separator: ".").last ?? "")
        let fileDirectory = ext.isEmpty ? boldDirectory : boldDirectory.appendingPathComponent(ext.uppercased())
        let file = url.lastPathComponent
//        if let nameFile = nameFile {
//            file = nameFile + "." + url.pathExtension
//        }
        let destinationURL = fileDirectory.appendingPathComponent(file)
        try? FileManager.default.createDirectory(at: fileDirectory, withIntermediateDirectories: true, attributes: [:])
        try? FileManager.default.removeItem(at: destinationURL)
        
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            DispatchQueue.main.async {[weak self] in
                self?.downloadCompletion((path: destinationURL, url: url))
            }
        } catch let error {
            print(error.localizedDescription)
            DispatchQueue.main.async {[weak self] in
                self?.downloadCompletion(nil)
            }
        }
    }
    
}
