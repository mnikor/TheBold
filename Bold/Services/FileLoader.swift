//
//  FileLoader.swift
//  Bold
//
//  Created by Admin on 21.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class FileLoader: NSObject {
    let downloadCompletion: (((path: URL, url: URL)?) -> Void)
    private var nameFile: String?
    
    init(downloadCompletion: @escaping (((path: URL, url: URL)?) -> Void)) {
        self.downloadCompletion = downloadCompletion
    }
    
    func load(from url: String, nameFile: String? = nil) {
        guard let url = URL(string: url) else { return }
        self.nameFile = nameFile
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
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
}

extension FileLoader: URLSessionDownloadDelegate {
    
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let downloadsPath = FileManager.default.urls(for: .documentDirectory, in: .userDomainMask)[0]
        let boldDirectory = downloadsPath.appendingPathComponent("Bold")
        let ext = String(url.lastPathComponent.split(separator: ".").last ?? "")
        let fileDirectory = ext.isEmpty ? boldDirectory : boldDirectory.appendingPathComponent(ext.uppercased())
        var file = url.lastPathComponent
        if let nameFile = nameFile {
            file = nameFile + "." + url.pathExtension
        }
        let destinationURL = fileDirectory.appendingPathComponent(file)
        try? FileManager.default.createDirectory(at: fileDirectory, withIntermediateDirectories: true, attributes: [:])
        try? FileManager.default.removeItem(at: destinationURL)
        
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            downloadCompletion((path: destinationURL, url: url))
        } catch let error {
            print(error.localizedDescription)
            downloadCompletion(nil)
        }
    }
    
}
