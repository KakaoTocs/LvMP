//
//  MainViewController.swift
//  LvMP
///Users/kakaotocs/Downloads/RazePlayer-Final.zip
//  Created by Jinu Kim on 27/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit
import RealmSwift

class HomeViewController: UIViewController {
    // file은 파일로 쓰고 폴더를 따로 만들지말고 해당 결로에 쓸때 폴더 생성인자를 true로 구현
    @IBOutlet weak var newAlbumsCollectionView: UICollectionView!
    @IBOutlet weak var playlistsTableView: UITableView!
    
    private var realm: Realm!
    private lazy var albums: Results<Album>! = {
        realm.objects(Album.self).sorted(byKeyPath: "saveDate", ascending: false)
    }()
    private var token: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.newAlbumsCollectionView.delegate = self
        self.newAlbumsCollectionView.dataSource = self
        self.newAlbumsCollectionView.allowsMultipleSelection = false
        
        realm = try! Realm()
        
        token = albums.observe({ change in
            self.newAlbumsCollectionView.reloadData()
        })
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == AlbumInfoViewController.segueIdentifier {
            let albumInfoVC = segue.destination as! AlbumInfoViewController
            if let index = self.newAlbumsCollectionView.indexPathsForSelectedItems?.first {
                albumInfoVC.albumsID = [albums[index.item].id]
//                if let superView = self.parent as? RootViewController {
//                    superView.backgroundImageToFront()
//                }
            }
        }
    }

}

//extension HomeViewController: UITableViewDelegate, UITableViewDataSource {
//
//    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
//        <#code#>
//    }
//
//    func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
//        <#code#>
//    }
//
//}
//
extension HomeViewController: UICollectionViewDelegate, UICollectionViewDataSource, UICollectionViewDelegateFlowLayout {
    
    func collectionView(_ collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        if self.albums.count > 9 {
            return 9
        } else {
            return self.albums.count
        }
    }
    
    func collectionView(_ collectionView: UICollectionView, cellForItemAt indexPath: IndexPath) -> UICollectionViewCell {
        let album = self.albums[indexPath.item]
        let cell = collectionView.dequeueReusableCell(withReuseIdentifier: NewAlbumCollectionViewCell.identifier, for: indexPath) as! NewAlbumCollectionViewCell
        
        // TODO: Album생성시 Artist없이 생성될 수 있는지 확인!!
        cell.refresh(with: album)
        
        return cell
        
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAt indexPath: IndexPath) -> CGSize {
        let width = (self.newAlbumsCollectionView.frame.width - 20) / 3
        let height = self.newAlbumsCollectionView.frame.height - 10
        return CGSize(width: width, height: height)
    }
    
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAt section: Int) -> CGFloat {
        return 5.0
    }

    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
