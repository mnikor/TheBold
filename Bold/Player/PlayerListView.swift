//
//  PlayerListView.swift
//  Bold
//
//  Created by Alexander Kovalov on 6/24/19.
//  Copyright © 2019 Alexander Kovalov. All rights reserved.
//

import UIKit

class PlayerListView: UIView {

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var tableView: UITableView!
    
    var topTopAnchor : NSLayoutConstraint!
    var topBottomAnchor : NSLayoutConstraint!
    var superView: UIView!
    
    lazy var ListItems : [SongEntity] = {
        return AudioService.shared.tracks.compactMap { SongEntity(name: $0.trackName, duration: $0.duration)}
    }()
    
    @IBAction func tapHideListButton(_ sender: UIButton) {
        hideViewAnimate()
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
        
        tableView.dataSource = self
        tableView.delegate = self
        tableView.tableFooterView = UIView()
        tableView.rowHeight = UITableView.automaticDimension
        tableView.estimatedRowHeight = 50
    }
    
    func configView(superView: UIView) {
        
        self.superView = superView
        
        let frame = CGRect(x: 0, y: superView.bounds.size.height, width: superView.bounds.size.width, height: superView.bounds.size.height)
        
        self.frame = frame
        superView.addSubview(self)
        self.translatesAutoresizingMaskIntoConstraints = false
        
        topTopAnchor = self.topAnchor.constraint(equalTo: superView.topAnchor)
        topBottomAnchor = self.topAnchor.constraint(equalTo: superView.bottomAnchor)
        topTopAnchor.isActive = false
        
        NSLayoutConstraint.activate([
            self.heightAnchor.constraint(equalToConstant: superView.bounds.size.height),
            self.leftAnchor.constraint(equalTo: superView.leftAnchor),
            self.rightAnchor.constraint(equalTo: superView.rightAnchor),
            topBottomAnchor])
        
        updateData()
        showViewAnimate()
    }
    
    func updateData() {
        ListItems = AudioService.shared.tracks.compactMap { SongEntity(name: $0.trackName, duration: $0.duration)}
    }

    func showViewAnimate() {
        UIView.animate(withDuration: 0.3) {
            self.topBottomAnchor.isActive = false
            self.topTopAnchor.isActive = true
            self.superView.layoutIfNeeded()
        }
    }
    
    func hideViewAnimate() {
        UIView.animate(withDuration: 0.3, animations: {
            self.topTopAnchor.isActive = false
            self.topBottomAnchor.isActive = true
            self.superView.layoutIfNeeded()
        }, completion: { [unowned self] (_) in
            self.removeFromSuperview()
        })
    }
    
}


extension PlayerListView: UITableViewDelegate, UITableViewDataSource {
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return ListItems.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeReusableCell(indexPath: indexPath) as PlayerListTableViewCell
        cell.config(item: ListItems[indexPath.row])
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        tableView.deselectRow(at: indexPath, animated: false)
        
        AudioService.shared.input(.play(trackIndex: indexPath.row))
        hideViewAnimate()
    }
    
}


struct SongEntity {
    var name: String
    var duration: String
}
