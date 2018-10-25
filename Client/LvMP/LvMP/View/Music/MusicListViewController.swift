//
//  MusicListViewController.swift
//  LvMP
//
//  Created by Jinu Kim on 03/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit
import RealmSwift

class MusicListViewController: UIViewController {

    private var realm: Realm!
    private var musics: Results<Music>!
    private var token: NotificationToken!
    
    @IBOutlet weak var musicsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        self.musicsTableView.delegate = self
        self.musicsTableView.dataSource = self
        
        realm = try! Realm()
        musics = realm.objects(Music.self).sorted(byKeyPath: "title", ascending: true)
        token = musics.observe({ change in
            self.musicsTableView.reloadData()
        })
    }
}

extension MusicListViewController: UITableViewDelegate, UITableViewDataSource {
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return musics.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let music = musics[indexPath.row]
        guard let cell = self.musicsTableView.dequeueReusableCell(withIdentifier: MusicTableViewCell.identifier, for: indexPath) as? MusicTableViewCell else {
            return UITableViewCell()
        }
        
        cell.refresh(with: music)
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        return 75.0
    }
}
