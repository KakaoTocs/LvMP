//
//  PlayListBookViewController.swift
//  AudioPlayer
//
//  Created by DGSW_TEACHER on 2016. 12. 2..
//  Copyright © 2016년 dgsw. All rights reserved.
//

import UIKit

/*
var Aarray = [[String]]()
var PlayList = [String]()
var ListMusic = [String]()
 */
var PlayListBook : [[String]] = [[String]](repeating:[String](repeating: "", count: 0), count: 3)
var PlayList : [String] = [String](repeating: "", count: 0)

class PlayListViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var PlayListTable: UITableView!
    
    func Setting(){
        PlayList.append("Lv")
        PlayList.append("POP")
        PlayList.append("Drama Ost")
        
        PlayListBook[0].append("01. 블랙홀 (Feat. 에일리)")
        PlayListBook[0].append("Don`t Wanna Know")
        
        PlayListBook[1].append("Justin Bieber-10-Pray (Acoustic Ver.)")
        PlayListBook[1].append("디어 클라우드-01-Remember-320")
        PlayListBook[1].append("먼데이 키즈-01-하기 싫은 말")
        
        PlayListBook[2].append("아이오아이 (I.O.I)-02-잠깐만")
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { //섹션 개수를 1로 설정
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //섹션당 열개수 전달
        return PlayList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "PlayListCell", for: indexPath) as! PlayListTableViewCell
        
        cell.PlayListTitle.text = PlayList[indexPath.row]
        return cell
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()
        //TestImage.image=UIImage(named: "image.jpg")
        Setting()
        
        PlayListTable.dataSource = self
        PlayListTable.delegate = self
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) {
        PlayListTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgListBook"{
            let cell = sender as! UITableViewCell
            let indexPath = self.PlayListTable.indexPath(for: cell)
            let PlayListView = segue.destination as! PlayListBookTableViewController
            
            PlayListView.Current = indexPath!.row //목록중 선택한 노래 넘버 전달
        }
    }
}
