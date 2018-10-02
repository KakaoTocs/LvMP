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
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var lyrics: String = ""
    @objc dynamic var playTime: UInt32 = 0
    @objc dynamic var url: String = ""
    @objc dynamic var type: String = ""
    @objc dynamic var artist: Artist?
    @objc dynamic var album: Album?
    
//    override func primary
    
    convenience init(name: String, lyrics: String, url: String, artist: Artist, album: Album) {
        self.init()
        self.name = name
        self.lyrics = lyrics
        self.url = url
        self.artist = artist
        self.album = album
    }
    
    func save(file: Data) {
        let realm: Realm! = try! Realm()
        var fileURL: URL = URL(string: self.url)!
        fileURL.appendPathComponent("\(name).\(type)")
        do {
            try realm.write {
                realm.add(self)
            }
        } catch {
            print("Error >> Save >> Music")
        }
    }
    
    func delete() {
        let realm: Realm! = try! Realm()
        do {
            try realm.write {
                realm.delete(self)
            }
        } catch {
            print("Error >> Delete >> Music")
        }
    }
}
