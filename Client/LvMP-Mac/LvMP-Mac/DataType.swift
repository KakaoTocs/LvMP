//
//  DataType.swift
//  LvMP-Mac
//
//  Created by Jinu Kim on 30/09/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation

class Music {
    let title: String
    let artist: String
    let album: String
    let size: UInt64
    let type: String
    let artwork: Data
    let playTime: UInt64
    let file: Data
    
    init(title: String, artist: String, album: String, size: UInt64, type: String, artwork: Data, playTime: UInt64, file: Data) {
        self.title = title
        self.artist = artist
        self.album = album
        self.size = size
        self.type = type
        self.artwork = artwork
        self.playTime = playTime
        self.file = file
    }
}

class Folder {
    let name: String
    let type = "Folder"
    var files: [Music] = []
    var folders: [Folder] = []
    var totalCount: Int {
        return files.count + folders.count
    }
    
    init(name: String) {
        self.name = name
    }
}
