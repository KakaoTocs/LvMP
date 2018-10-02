//
//  HomeListViewController.swift
//  AudioPlayer
//
//  Created by DGSW_TEACHER on 2016. 11. 20..
//  Copyright © 2016년 dgsw. All rights reserved.
//

import UIKit
import AVFoundation
import MediaPlayer
import Foundation

var MusicCount = 0
var Now = 0

//var documentsUrl : NSURL!

var MusicList = [""]
var SingerList = [""]
var AlbumList = [""]
var MusicArt = [""]

let documentsUrl =  FileManager.default.urls(for: .documentDirectory, in: .userDomainMask).first!

class HomeListViewController: UIViewController, UITableViewDataSource, AVAudioPlayerDelegate, UISearchBarDelegate, UITableViewDelegate {
    
    var audioFileURL : NSURL!
    var audioPath : NSURL!
    var ImageTemp : NSData!
    
    @IBOutlet weak var MusicLIstTable: UITableView!;
    
    
    
    func checkMusicList(){
        do {
            //documentsUrl = NSURL(fileURLWithPath: "/var/mobile/Containers/Data/Application/2ED8312C-557E-4D49-A4C7-922FE718C567/Documents/")
            
            let directoryContents = try FileManager.default.contentsOfDirectory(at: documentsUrl, includingPropertiesForKeys: nil, options: [])
            print(documentsUrl)
            
            let mp3Files = directoryContents.filter{ $0.pathExtension == "mp3" }
            //print("mp3 urls:", mp3Files)
            let mp3FileNames = mp3Files.flatMap({$0.deletingPathExtension().lastPathComponent})
//            print("mp3 list: ", mp3FileNames)
            
            MusicList = mp3FileNames
            
        } catch let error as NSError {
            print(error.localizedDescription)
        }
    }
    
    func MusicLoading()
    {
        var cur = 0
        for List in MusicList{
            audioFileURL = Bundle(url: documentsUrl)!.url(forResource: List, withExtension: "mp3")! as NSURL
            print(audioFileURL)
            let ListItem = AVPlayerItem(url: audioFileURL as URL)
            let matadataList = ListItem.asset.metadata
            
            for item in matadataList {
                
                if item.commonKey == "artist" {
                    if SingerList[0] == ""{
                        SingerList[0] = item.stringValue!
                    }
                    else{
                        SingerList.append(item.stringValue!)
                    }
                }
                
                if item.commonKey == "albumName"{
                    if AlbumList[0] == ""{
                        AlbumList[0] = item.stringValue!
                    }
                    else{
                        AlbumList.append(item.stringValue!)
                    }
                }
                cur += 1
            }
        }
    }
    
    func numberOfSectionsInTableView(tableView: UITableView) -> Int { //섹션 개수를 1로 설정
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int { //섹션당 열개수 전달
        return MusicList.count
    }
    
    func MusicArtLoading(ImageTempCur : Int)
    {
        audioFileURL = Bundle(url: documentsUrl)!.url(forResource: MusicList[ImageTempCur], withExtension: "mp3")! as? NSURL
        let ListItem = AVPlayerItem(url: audioFileURL as URL)
            let matadataList = ListItem.asset.metadata
            
            for item in matadataList {
                if item.commonKey == "artwork"{
                    //let Image = UIImage(data: item.value as! NSData)
                    let Image = UIImage(data: (item.value as! NSData) as Data)
                    ImageTemp = UIImagePNGRepresentation(Image!)! as NSData
                }
            }
    }

    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell{
        let cell = tableView.dequeueReusableCell(withIdentifier: "MusicListCell", for: indexPath) as! ListTableViewCell
        
            cell.MusicTitle.text = MusicList[indexPath.row]
            cell.MusicSinger.text = SingerList[indexPath.row]
        MusicArtLoading(ImageTempCur: indexPath.row)
        cell.MusicWork.image =  UIImage(data: ImageTemp! as Data)
        return cell
    }
    
    private func tableView(tableView: UITableView, canEditRowAtIndexPath indexPath: NSIndexPath) -> Bool
    {
        return true
    }
    
    override func viewDidLoad() {
        func getDocumentsDirectory() {
            let paths = FileManager.default.urls(for: .documentDirectory , in: .userDomainMask)
            let documentsDirectory = paths[0]
            print(documentsDirectory)
        }
        getDocumentsDirectory()
        
        super.viewDidLoad()
        checkMusicList()
        MusicLoading()
        
        MusicLIstTable.dataSource = self
        MusicLIstTable.delegate = self
        
        self.navigationItem.leftBarButtonItem = self.editButtonItem //Edit버튼 삭제\
    }
        
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
    }
    
    override func viewWillAppear(_ animated: Bool) { //뷰가 노출 될떄마다 리스트 데이터 다시 불러옴
        MusicLIstTable.reloadData()
    }
    
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        if segue.identifier == "sgPlay"{
            let cell = sender as! UITableViewCell
            let indexPath = self.MusicLIstTable.indexPath(for: cell)
            let PlayerView = segue.destination as! PlayerViewController
            
            if(Now == 1)
            {
                PlayerView.StopAudio()
                print(Now)
            }
            
            PlayerView.Current = indexPath!.row //목록중 선택한 노래 넘버 전달
        }
    }
}
