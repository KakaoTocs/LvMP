//
//  Playlist.swift
//  LvMP
//
//  Created by Jinu Kim on 27/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation
import RealmSwift

class PlayList: Object {
    // MARK: - Property
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    let musicsID = List<String>()
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    // MARK: - Initalizer
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
