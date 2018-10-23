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
    // MARK: - Property
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = "제목 없음"
    @objc dynamic var lyrics: String = "가사 없음"
    @objc dynamic var playtime: Int = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var artwork: Data?
    @objc dynamic var saveDate: Date = Date()
    @objc dynamic var artist: Artist?
    @objc dynamic var album: Album?
    
    var playtimeString: String {
        get {
            return playtimeToString(total: playtime)
        }
    }
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Initalizer
    private convenience init(id: String, title: String, lyrics: String, playTime: Int, url: String, type: String) {
        self.init()
        self.id = id
        self.title = title
        self.lyrics = lyrics
        self.playtime = playTime
        self.url = url
        self.type = type
    }

    private convenience init(id: String, title: String, lyrics: String, playTime: Int, url: String, type: String, artwork: Data, artist: Artist, album: Album) {
        self.init(id: id, title: title, lyrics: lyrics, playTime: playTime, url: url, type: type)
        self.artwork = artwork
        self.artist = artist
        self.album = album
    }
    
    convenience init?(id: String, url: String, type: String) {
        var titleTemp = "제목 없음"
        var lyricsTemp = "가사 없음"
        var playTimeTemp = 0
        guard let urlTemp = URL(string: url) else {
            return nil
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
        Artist.save(artist: artistTemp)
        Album.save(album: albumTemp)
        self.init(id: id, title: titleTemp, lyrics: lyricsTemp, playTime: playTimeTemp, url: url, type: type, artwork: artworkTemp, artist: artistTemp, album: albumTemp)

    }
    
    // MARK: - Method
    func getArtworkImage() -> UIImage? {
        if let artworkData = self.artwork {
            return UIImage(data: artworkData)
        } else {
            return nil
        }
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
            try realm.write {
                realm.add(music)
            }
        } catch {
            print("Error >> Music >> save(): Realm write error")
        }
    }
    
    static func delete(music: Music) -> Bool {
        // TODO: - 파일삭제후 완료시 림에서 삭제
        let realm = try! Realm()
        let result = FilesManager.shared.removeFile(at: URL(string: music.url)!)
        if result {
            do {
                try realm.write {
                    realm.delete(music)
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
