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
    
    static let emptyArtist = Artist(name: "아티스트가 없습니다.")
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
    func updateProfile(file data: Data) {
        // TODO - 받은 데이터 Realm에 저장
    }
}
