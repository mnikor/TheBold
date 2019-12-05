//
//  FileLoader.swift
//  Bold
//
//  Created by Admin on 21.11.2019.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import Foundation

class FileLoader: NSObject {
    let downloadCompletion: (((path: String, url: String)?) -> Void)
    
    init(downloadCompletion: @escaping (((path: String, url: String)?) -> Void)) {
        self.downloadCompletion = downloadCompletion
    }
    
    func load(from url: String) {
        guard let url = URL(string: url) else { return }
        let urlSession = URLSession(configuration: .default, delegate: self, delegateQueue: OperationQueue())
        let downloadTask = urlSession.downloadTask(with: url)
        downloadTask.resume()
    }
    
}

extension FileLoader: URLSessionDownloadDelegate {
    func urlSession(_ session: URLSession, downloadTask: URLSessionDownloadTask, didFinishDownloadingTo location: URL) {
        guard let url = downloadTask.originalRequest?.url else { return }
        let downloadsPath = FileManager.default.urls(for: .downloadsDirectory, in: .allDomainsMask)[0]
        let boldDirectory = downloadsPath.appendingPathComponent("Bold")
        let ext = String(url.lastPathComponent.split(separator: ".").last ?? "")
        let fileDirectory = ext.isEmpty ? boldDirectory : boldDirectory.appendingPathComponent(ext.uppercased())
        let destinationURL = fileDirectory.appendingPathComponent(url.lastPathComponent)
        try? FileManager.default.createDirectory(at: fileDirectory, withIntermediateDirectories: true, attributes: [:])
        try? FileManager.default.removeItem(at: destinationURL)
        
        do {
            try FileManager.default.copyItem(at: location, to: destinationURL)
            downloadCompletion((path: destinationURL.absoluteString, url: url.absoluteString))
        } catch let error {
            print(error.localizedDescription)
            downloadCompletion(nil)
        }
    }
    
}
