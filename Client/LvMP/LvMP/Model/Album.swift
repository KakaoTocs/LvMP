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
    // MARK: - Property
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var saveDate: Date = Date()
    @objc dynamic var artist: Artist?
    let musics = LinkingObjects(fromType: Music.self, property: "album")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Initalizer
    convenience init(name: String, artist: Artist) {
        self.init()
        self.name = name
        self.artist = artist
    }
    
    // MARK: - Method
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
