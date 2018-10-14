//
//  Music.swift
//  LvMP
//
//  Created by Jinu Kim on 27/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation
import RealmSwift

class Music: Object {
    @objc dynamic var id: String = ""
    @objc dynamic var title: String = ""
    @objc dynamic var lyrics: String = ""
    @objc dynamic var playTime: UInt32 = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var artist: Artist?
    @objc dynamic var album: Album?
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(id: String, title: String, lyrics: String, playTime: UInt32, url: String, type: String, artist: Artist? = nil, album: Album? = nil) {
        self.init()
        self.id = id
        self.title = title
        self.lyrics = lyrics
        self.playTime = playTime
        self.url = url
        self.type = type
        self.artist = artist
        self.album = album
    }
    
    convenience init(id: String, at url: URL) {
        self.init()
    }
    
    func save(file: Data) {
        var fileURL: URL = URL(string: self.id)!
        fileURL.appendPathComponent(id + ".\(type)")
        self.url = fileURL.absoluteString
        let result = FilesManager.shared.writeFile(at: fileURL, file: file)
        if !result {
            print("Error >> Music >> save: file write error")
        }
        do {
            try self.realm?.write {
                realm?.add(self)
            }
        } catch {
            print("Error >> Save >> Music >> save: db write error")
        }

    }
    
    func delete() {
        do {
            try self.realm?.write {
                realm?.delete(self)
            }
        } catch {
            print("Error >> Delete >> Music")
        }
    }

}
