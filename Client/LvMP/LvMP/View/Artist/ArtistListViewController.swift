//
//  ArtistListViewController.swift
//  LvMP
//
//  Created by Jinu Kim on 03/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit
import RealmSwift

class ArtistListViewController: UIViewController {
    
    private var realm: Realm!
    private var artists: Results<Artist>!
    private var token: NotificationToken!

    @IBOutlet weak var artistsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.artistsTableView.delegate = self
        self.artistsTableView.dataSource = self
        
        
        realm = try! Realm()
        artists = realm.objects(Artist.self).sorted(byKeyPath: "name", ascending: true)
        token = artists.observe({ change in
            self.artistsTableView.reloadData()
        })
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AlbumInfoViewController.segueIdentifier {
            if let albumInfoVC = segue.destination as? AlbumInfoViewController,
                let index = self.artistsTableView.indexPathsForSelectedRows?.first {
                print(artists[index.item].albums )
                albumInfoVC.albums = artists[index.item].al
            }
        }
    }

}

extension ArtistListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return artists.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let artist = artists[indexPath.row]
        guard let cell = self.artistsTableView.dequeueReusableCell(withIdentifier: ArtistTableViewCell.identifier, for: indexPath) as? ArtistTableViewCell else {
            return UITableViewCell()
        }
        
        cell.nameLabel.text = artist.name
        cell.albumCountLabel.text = "앨범 \(artist.albums.count)개"
        cell.musicCountLabel.text = "곡 \(artist.musics.count)개"
        let totalPlaytime = artist.musics.reduce(0) { $0 + $1.playTime }
        cell.playtimeLabel.text = String(format: "%2d분 %2d초", totalPlaytime / 60, totalPlaytime % 60)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
