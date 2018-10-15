//
//  Album.swift
//  LvMP
//
//  Created by Jinu Kim on 27/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation
import RealmSwift

class Album: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var artist: Artist?
    let musics = LinkingObjects(fromType: Music.self, property: "album")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
//    static let emptyAlbum: Album = {
//        let defaults = UserDefaults.standard
//        let emptyAlbumID = defaults.object(forKey: "emptyAlbumID") as! String
//        let realm = try! Realm()
//        return realm.object(ofType: Album.self, forPrimaryKey: emptyAlbumID)!
//    }()
    
    
    convenience init(name: String, artist: Artist) {
        self.init()
        self.name = name
        self.artist = artist
    }
    
    static func save(album: Album) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(album)
            }
        } catch {
            print("Error >> Album >> save(): Realm write error")
        }
    }
    
    static func delete(album: Album) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.delete(album)
            }
        } catch {
            print("Error >> Album >> delete(): Realm delete error")
        }
    }
    
    static func getAlbum(name: String) -> Album? {
        let realm = try! Realm()
        if let album = realm.objects(Album.self).filter("name = %@", name).first {
            return album
        } else {
            return nil
        }
    }
    
}
