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
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = "제목 없음"
    @objc dynamic var lyrics: String = "가사 없음"
    @objc dynamic var playTime: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var artwork: Data?
    @objc dynamic var artist: Artist?
    @objc dynamic var album: Album?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    convenience init(title: String, lyrics: String, playTime: UInt64, url: String, type: String) {
//        self.init()
//        self.title = title
//        self.lyrics = lyrics
//        self.playTime = playTime
//        self.url = url
//        self.type = type
//    }
//    
//    convenience init(title: String, lyrics: String, playTime: UInt64, url: String, type: String, artwork: Data, artist: Artist, album: Album) {
//        self.init(title: title, lyrics: lyrics, playTime: playTime, url: url, type: type)
////        String(format: "%2d분 %2d초", file.playTime / 60, file.playTime % 60)
//        self.artwork = artwork
//        self.artist = artist
//        self.album = album
//    }
    
//    static func `init`(id: String, url: String, type: String) -> Music? {
//        var music = Music()
//        music.id = id
//        music.title = "제목 없음"
//        music.lyrics = "가사 없음"
//        music.playTime = 0
//        music.url = url
//        music.type = type
//        music.album = Album.emptyAlbum
//        music.artist = Artist.emptyArtist
//
//        guard let urlTemp = URL(string: url) else {
//            return nil
//        }
//        let musicFile = AVPlayerItem(url: urlTemp)
//        let metaData = musicFile.asset.metadata
//        var albumNameTemp: String?
//        var artistTemp: Artist?
//
//        for item in metaData {
//            switch item.commonKey?.rawValue {
//            case "title":
//                if let title = item.stringValue {
//                    music.title = title
//                }
//            case "ko":
//                if let lyrics = item.stringValue {
//                    music.lyrics = lyrics
//                }
//            case "artist":
//                if let artistName = item.stringValue {
//                    music.artist = Artist(name: artistName)
//                    artistTemp = music.artist
//                }
//            case "albumName":
//                if let albumName = item.stringValue {
//                    albumNameTemp = albumName
//                }
//            case "artwork":
//                music.artwork = item.dataValue
//            default:
//                break
//            }
//        }
//        if let albumName = albumNameTemp,
//            let artist = artistTemp {
//            music.album = Album(name: albumName, artist: artist)
//        }
//        do {
//            let audioPlayer = try AVAudioPlayer(contentsOf: urlTemp)
//            music.playTime = Int(audioPlayer.duration)
//        } catch {
//            print("Error >> Music >> init?(with file: Data, detail type: String): duration error")
//        }
//
//        return music
//    }
    
    
    convenience init?(id: String, url: String, type: String) {
        self.init()
        var titleTemp = "제목 없음"
        var lyricsTemp = "가사 없음"
        var playTimeTemp = 0
        guard let urlTemp = URL(string: url) else {
            return
        }
        var artworkTemp = Data()
        var artistTemp = Artist.getArtist(name: "아티스트가 없습니다.")!
        var albumTemp = Album.getAlbum(name: "앨범이 없습니다.")!
        var albumNameTemp: String?

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
                    if let gotArtist = Artist.getArtist(name: artistName) {
                        artistTemp = gotArtist
                    } else {
                        artistTemp = Artist(name: artistName)
                    }
                }
            case "albumName":
                if let albumName = item.stringValue {
                    if let gotAlbum = Album.getAlbum(name: albumName) {
                        albumTemp = gotAlbum
                    } else {
                        albumNameTemp = albumName
                    }
                }
            case "artwork":
                artworkTemp = item.dataValue!
            default:
                break
            }
        }
        if let albumName = albumNameTemp {
            albumTemp = Album(name: albumName, artist: artistTemp)
        }

        do {
            let audioPlayer = try AVAudioPlayer(contentsOf: urlTemp)
            playTimeTemp = Int(audioPlayer.duration)
        } catch {
            print("Error >> Music >> init?(with file: Data, detail type: String): duration error")
        }
        self.id = id
        self.title = titleTemp
        self.lyrics = lyricsTemp
        self.playTime = playTimeTemp
        self.url = url
        self.artwork = artworkTemp
        self.type = type
        Artist.save(artist: artistTemp)
        Album.save(album: albumTemp)
        self.artist = artistTemp
        self.album = albumTemp

    }
    
    // TODO: - pc에서 파일+확장자명 전달 -> 앱에서 UUID+확장자로 저장 -> 읽어서 Music객체 생성 -> 인스턴스+경로 Realm에 저장 ->
    static func saves(files datas: [Data], with types: [String]) {
        for index in datas.indices {
            let newID = UUID().uuidString
            let url = FilesManager.shared.rootDirectory.appendingPathComponent(newID + ".\(types[index])")
            let result = FilesManager.shared.writeFile(at: url, file: datas[index])
            if result {
                if let music = Music(id: newID, url: url.absoluteString, type: types[index]) {
                    Music.save(music: music)
                } else {
                    print("Error >> Music >> saves(files datas: [Data], with types: [String]): Create Music instance error")
                }
            } else {
                let result = FilesManager.shared.removeFile(at: url)
                if !result {
                    print("Error >> Music >> saves(files datas: [Data], with types: [String]): Create Music instance error -> remove file error")
                }
                print("Error >> Music >> saves(files datas: [Data], with types: [String]): Save file error")
            }
            
        }
    }
    
    // TODO - 저장 성공여부 반환 -> Bool
    static func save(music: Music) {
        let realm = try! Realm()
        do {
            dump(self)
            try realm.write {
                realm.add(music)
            }
        } catch {
            print("Error >> Music >> save(): Realm write error")
        }
    }
    
    func delete() -> Bool {
        // TODO: - 파일삭제후 완료시 림에서 삭제
        let result = FilesManager.shared.removeFile(at: URL(string: self.url)!)
        if result {
            do {
                try self.realm?.write {
                    self.realm?.delete(self)
                }
            } catch {
                print("Error >> Music >> delete(): Realm delete error")
                return  false
            }
            return  true
        } else {
            print("Error >> Music >> delete(): File delete error")
            return  false
        }
    }

}
