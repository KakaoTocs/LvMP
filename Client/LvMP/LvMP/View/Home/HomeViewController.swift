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
    @IBAction func test(_ sender: Any) {
        let storyboard = UIStoryboard(name: "Player", bundle: nil)
        let VC = storyboard.instantiateViewController(withIdentifier: "playerView") as! PlayerViewController
        
        self.navigationController?.pushViewController(VC, animated: true)
    }
    // file은 파일로 쓰고 폴더를 따로 만들지말고 해당 결로에 쓸때 폴더 생성인자를 true로 구현
    // realm데이터 삭제시 파일 삭제후 realm에서 삭제
    // 서버에서 받은 후 데이터 저장
    // 노래정보를 저장할 싱글톤 필요없음 -> Realm으로 실시간으로 새로고침해 사용가능e
    @IBOutlet weak var newAlbumsCollectionView: UICollectionView!
    @IBOutlet weak var playlistsTableView: UITableView!
    
    private var realm: Realm!
    private var albums: Results<Album>!
    private var token: NotificationToken!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // 노래 ㅓ장시 경로 확인 파일 url렘에 저장후 url로 노재 재생
        // Do any additional setup after loading the view.
//        FilesManager.shared.test()
        self.newAlbumsCollectionView.delegate = self
        self.newAlbumsCollectionView.dataSource = self
//        self.navigationController?.navigationBar.barTintColor = UIColor.clear
        realm = try! Realm()
        albums = realm.objects(Album.self).sorted(byKeyPath: "saveDate", ascending: true)
        
        token = albums.observe({ change in
            self.newAlbumsCollectionView.reloadData()
        })
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
        
        cell.nameLabel.text = album.name
        // TODO: Album생성시 Artist없이 생성될 수 있는지 확인!!
        cell.artistLabel.text = album.artist!.name
        cell.artworkImageView.image = album.musics.first?.getArtworkImage()
        cell.artworkImageView.mask = cell.imageMaskView
        
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
    
//    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAt section: Int) -> CGFloat {
//        return 10.0
//    }
//
    func collectionView(_ collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAt section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 5, left: 5, bottom: 5, right: 5)
    }
}
