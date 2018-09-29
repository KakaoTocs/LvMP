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
    @objc dynamic var data: Data?
    @objc dynamic var artist: Artist?
    @objc dynamic var album: Album?
    
//    override func primary
    
    convenience init(name: String, lyrics: String, data: Data, artist: Artist, album: Album) {
        self.init()
        self.name = name
        self.lyrics = lyrics
        self.data = data
        self.artist = artist
        self.album = album
    }
}
