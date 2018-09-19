//
//  PlayListBookTableViewController.swift
//  AudioPlayer
//
//  Created by DGSW_TEACHER on 2016. 12. 3..
//  Copyright © 2016년 dgsw. All rights reserved.
//

import UIKit

class PlayListBookTableViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {

    var Current = 0
    
    @IBOutlet weak var TestImage: UIImageView!
    @IBOutlet weak var PlayListTable: UITableView!
    @IBOutlet weak var PlayListTitle: UILabel!
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return PlayListBook[Current].count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell", for: indexPath as IndexPath) as! ListTableViewCell
        var i = 0
        let MusicNameCpy : String = PlayListBook[Current][indexPath.row]
        cell.MusicTitle.text = MusicNameCpy
        
        for Music in MusicList
        {
            if(Music == MusicNameCpy)
            {
                cell.MusicSinger.text = SingerList[i]
            }
            //print(PlayListBook[Current][indexPath.row])
        
            i += 1
            /*
            MusicArtLoading(indexPath.row)
            cell.MusicWork.image =  UIImage(data: ImageTemp!)
            */
        }
        return cell
    }
    
    func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        return true
    }

    override func viewDidLoad() {
        TestImage.image = UIImage(named: "image.jpg")
        super.viewDidLoad()
        PlayListTitle.text = PlayList[Current]
        print(PlayList[Current])
        
        PlayListTable.dataSource = self
        PlayListTable.delegate = self
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PlayListTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgPlay"{
            let cell = sender as! UITableViewCell
            let indexPath = self.PlayListTable.indexPath(for: cell)
            let PlayerView = segue.destination as! PlayerViewController
            var i = 0
            let MusicNameCpy : String = PlayListBook[Current][indexPath!.row]
            
            for Music in MusicList
            {
                if(Music == MusicNameCpy)
                {
                    break
                }
                i += 1
            }
            PlayerView.Current = i //목록중 선택한 노래 넘버 전달
        }
    }
}
