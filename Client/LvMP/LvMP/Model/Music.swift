//
//  Music.swift
//  LvMP
//
//  Created by Jinu Kim on 27/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation
import RealmSwift
import AVFoundation

class Music: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var title: String = "제목 없음"
    @objc dynamic var lyrics: String = "가사 없음"
    @objc dynamic var playTime: UInt64 = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var artwork: Data?
    @objc dynamic var artist: Artist!
    @objc dynamic var album: Album!
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(title: String, lyrics: String, playTime: UInt64, url: String, type: String) {
        self.init()
        self.title = title
        self.lyrics = lyrics
        self.playTime = playTime
        self.url = url
        self.type = type
    }
    
    convenience init(title: String, lyrics: String, playTime: UInt64, url: String, type: String, artwork: Data? = nil, artist: Artist, album: Album) {
        self.init(title: title, lyrics: lyrics, playTime: playTime, url: url, type: type)
//        String(format: "%2d분 %2d초", file.playTime / 60, file.playTime % 60)
        self.artwork = artwork
        self.artist = artist
        self.album = album
    }
    
    convenience init(with file: Data, detail type: String) {
        self.init()
        var titleTemp = "제목 없음"
        var lyricsTemp = "가사 없음"
        var playTimeTemp: UInt64 = 0
        let urlTemp = FilesManager.shared.rootDirectory.appendingPathComponent(self.id + ".\(type)")
        var artworkTemp: Data?
        var artistTemp: Artist?
        var albumTemp: Album?
        var albumNameTemp: String?
        
        let result = FilesManager.shared.writeFile(at: urlTemp, file: file)
        if result {
            let musicFile = AVPlayerItem(url: urlTemp)
            let metaData = musicFile.asset.metadata
            
            for item in metaData {
                switch item.commonKey?.rawValue {
                case "title":
                    if let title = item.stringValue {
                        titleTemp = title
                    }
                case "ko":
                    if let lyrics = item.stringValue {
                        lyricsTemp = lyrics
                    }
                case "artist":
                    if let artistName = item.stringValue {
                        artistTemp = Artist(name: artistName)
                    } else {
                        // TODO: - 아티스트 없는 파일용 빈 인스턴스 생성후 사용
                        artistTemp = Artist.emptyArtist
                    }
                case "albumName":
                    if let albumName = item.stringValue {
                        albumNameTemp = albumName
                    } else {
                        albumTemp = Album
                    }
                case "artwork":
                    artworkTemp = item.dataValue
                default:
                    break
                }
            }
            let albumTemp = Album(name: albumName, artist: self.artist)
            if
            
            do {
                let audioPlayer = try AVAudioPlayer(contentsOf: urlTemp)
                playTimeTemp = UInt64(audioPlayer.duration)
            } catch {
                print("Error >> Music >> init?(with file: Data, detail type: String): duration error")
            }
        } else {
//            return nil
        }
        
    }
    // TODO: - pc에서 파일+확장자명 전달 -> 앱에서 UUID+확장자로 저장 -> 읽어서 Music객체 생성 -> 인스턴스+경로 Realm에 저장 ->
//    func save(files datas: [Data], with types: [String]) {
//
//    }
    
    func save(with file: Data, detail type: String) {
        let url = FilesManager.shared.rootDirectory.appendingPathComponent(self.id + ".\(type)")
        let result = FilesManager.shared.writeFile(at: url, file: file)
        if result {
            do {
                try self.realm?.write {
                    realm?.add(self)
                }
            } catch {
                print("Error >> Save >> Music >> save: db write error")
            }
        } else {
            print("Error >> Music >> save: file write error")
        }
    }
    
    func delete() {
        // TODO: - 파일삭제후 완료시 림에서 삭제
        do {
            try self.realm?.write {
                realm?.delete(self)
            }
        } catch {
            print("Error >> Delete >> Music")
        }
    }
    
    private func metadataFromFile(at url: url) -> (metadatalist type) {
        
    }

}
