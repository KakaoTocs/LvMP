//
//  Playlist.swift
//  LvMP
//
//  Created by Jinu Kim on 27/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation
import RealmSwift
typealias MusicList = PlayList
// MusicList, PlayList 2개가 필요한 이유는 한개는 재생목록, 나머지 하나는 현제 재생중인 음악들의 목록

class PlayList: Object {
    @objc dynamic var id: String = UUID().uuidString
    @objc dynamic var name: String = ""
    @objc dynamic var musicsID: [String] = []
    
    override static func primaryKey() -> String? {
        return "id"
    }
    
    convenience init(name: String) {
        self.init()
        self.name = name
    }
}
