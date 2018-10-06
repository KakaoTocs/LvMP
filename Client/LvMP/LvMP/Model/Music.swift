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
    
    convenience init(title: String, lyrics: String, url: String, artist: Artist, album: Album) {
        self.init()
        self.title = title
        self.lyrics = lyrics
        self.url = url
        self.artist = artist
        self.album = album
    }
    
    func save(file: Data) {
        let realm: Realm! = try! Realm()
        var fileURL: URL = URL(string: self.id)!
        fileURL.appendPathComponent(id + ".\(type)")
        self.url = fileURL.absoluteString
        let result = FilesManager.shared.writeFile(at: fileURL, file: file)
        if result {
            do {
                try realm.write {
                    realm.add(self)
                }
            } catch {
                print("Error >> Save >> Music >> save: db write error")
            }
        } else {
            print("Error >> Music >> save: file write error")
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
