//
//  Artist.swift
//  LvMP
//
//  Created by Jinu Kim on 27/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation
import RealmSwift

class Artist: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var profile: Data?
    var profileImage: UIImage? {
        if let imageData = profile {
            return UIImage(data: imageData)
        } else {
            return nil
        }
    }
    let musics = LinkingObjects(fromType: Music.self, property: "artist")
    let albums = LinkingObjects(fromType: Album.self, property: "artist")
    
    override static func primaryKey() -> String? {
        return "id"
    }

    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    func updateProfile(imageData data: Data) {
        do {
            try self.realm?.write {
                self.profile = data
            }
        } catch {
            print("Error >> Artist >> updateProfile(imageData data: Data): Realm write error")
        }
    }
    
    static func save(artist: Artist) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(artist)
            }
        } catch {
            print("Error >> Artist >> save(): Realm write error")
        }
    }
    
    static func delete(artist: Artist) {
        let realm = try! Realm()
        do {
            try realm.write {
                realm.add(artist)
            }
        } catch {
            print("Error >> Album >> delete(): Realm delete error")
        }
    }
    
    static func getArtist(name: String) -> Artist? {
        let realm = try! Realm()
        if let artist = realm.objects(Artist.self).filter("name = %@", name).first {
            return artist
        } else {
            return nil
        }
    }
    
}
