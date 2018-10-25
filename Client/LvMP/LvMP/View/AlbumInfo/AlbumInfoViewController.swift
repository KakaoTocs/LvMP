//
//  AlbumInfoViewController.swift
//  LvMP
//
//  Created by Jinu Kim on 16/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit
import RealmSwift

class AlbumInfoViewController: UIViewController {
    
    static let segueIdentifier = "AlbumInfoSegue"
    
    @IBOutlet weak var albumInfoTableView: UITableView!
    
    var albumsID: [String] = []
    private var realm: Realm!
    private lazy var albums: Results<Album>! = {
        realm.objects(Album.self).filter("id IN %@", albumsID)
    }()
    private var token: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.albumInfoTableView.delegate = self
        self.albumInfoTableView.dataSource = self
        
        realm = try! Realm()
    }
}

extension AlbumInfoViewController: UITableViewDelegate, UITableViewDataSource {
    
    func numberOfSections(in tableView: UITableView) -> Int {
        return albums.count
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return albums[section].musics.count
    }
    
    func tableView(_ tableView: UITableView, viewForHeaderInSection section: Int) -> UIView? {
        let album = albums[section]
        guard let headerCell = albumInfoTableView.dequeueReusableCell(withIdentifier: AlbumInfoTableViewHeader.identifier) as? AlbumInfoTableViewHeader else {
            return nil
        }
        headerCell.layoutSubviews()
        headerCell.contentView.layoutSubviews()
        
        headerCell.artworkImageView.image = album.musics.first?.getArtworkImage()
        headerCell.artworkImageView.mask = headerCell.imageMaskView
        headerCell.nameLabel.text = album.name
        
        return headerCell
    }
    
    func tableView(_ tableView: UITableView, heightForHeaderInSection section: Int) -> CGFloat {
        return 100
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let music = albums[indexPath.section].musics[indexPath.item]
        guard let cell = albumInfoTableView.dequeueReusableCell(withIdentifier: AlbumInfoTableViewCell.identifier, for: indexPath) as? AlbumInfoTableViewCell else {
            print("Error >> AlbumInfoViewController: Create cell error")
            return UITableViewCell()
        }
        
        cell.refresh(with: music, at: indexPath.item)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 50
    }
}
