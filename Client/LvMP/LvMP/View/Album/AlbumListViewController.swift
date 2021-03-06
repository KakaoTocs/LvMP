//
//  AlbumListViewController.swift
//  LvMP
//
//  Created by Jinu Kim on 27/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit
import RealmSwift

class AlbumListViewController: UIViewController {
    
    @IBOutlet weak var albumsCollectionView: UICollectionView!
    
    private var realm: Realm!
    private lazy var albums: Results<Album>! = {
        realm.objects(Album.self).sorted(byKeyPath: "name", ascending: true)
    }()
    private var token: NotificationToken!

    override func viewDidLoad() {
        super.viewDidLoad()

        self.albumsCollectionView.delegate = self
        self.albumsCollectionView.dataSource = self
        self.albumsCollectionView.allowsMultipleSelection = false
        
        realm = try! Realm()
        
        token = albums.observe({ change in
            self.albumsCollectionView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AlbumInfoViewController.segueIdentifier {
            let albumInfoVC = segue.destination as! AlbumInfoViewController
            if let index = self.albumsCollectionView.indexPathsForSelectedItems?.first {
                albumInfoVC.albumsID = [albums[index.item].id]
            }
        }
    }
}

extension AlbumListViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return albums.count
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let album = self.albums[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: AlbumCollectionViewCell.identifier, for: indexPath) as! AlbumCollectionViewCell
        
        cell.refresh(with: album)
        
        return cell
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.albumsCollectionView.frame.width - 20) / 3
        
        return CGSize(width: width, height: width / 63 * 79)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
        
        return 5.0
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
