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
    private lazy var artists: Results<Artist>! = {
        realm.objects(Artist.self).sorted(byKeyPath: "name", ascending: true)
    }()
    private var token: NotificationToken!

    @IBOutlet weak var artistsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.artistsTableView.delegate = self
        self.artistsTableView.dataSource = self
        
        
        realm = try! Realm()
        token = artists.observe({ change in
            self.artistsTableView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AlbumInfoViewController.segueIdentifier {
            if let albumInfoVC = segue.destination as? AlbumInfoViewController,
                let index = self.artistsTableView.indexPathsForSelectedRows?.first {
                albumInfoVC.albumsID = self.artists[index.item].albums.filter{ _ in true }.map{ $0.id }
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
        
        cell.refresh(with: artist)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 100.0
    }
}
