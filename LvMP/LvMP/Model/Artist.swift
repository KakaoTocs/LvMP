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
    let musics = LinkingObjects(fromType: Music.self, property: "artist")
    let albums = LinkingObjects(fromType: Album.self, property: "artist")
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
    
//    required init() {
//        fatalError("init() has not been implemented")
//    }
}
