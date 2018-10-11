//
//  Converter.swift
//  LvMP
//
//  Created by Jinu Kim on 04/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import AVFoundation


func fileToMusic(at: URL) {
    let musicFile = AVPlayerItem(url: at)
    let metaData = musicFile.asset.metadata
    
    var title: String
    var artist: String
    var albumName: String
    var lyrics: String
    var artwork: Data
    
    for item in metaData {
        switch item.commonKey?.rawValue {
        case "title":
            title = item.stringValue ?? "제목 없음"
        case "artist":
            artist = item.stringValue ?? "아티스트 없음"
        case "albumName":
            albumName = item.stringValue ?? "앨범명 없음"
        case "artwork":
            artwork = item.dataValue ?? Data()
        case "ko":
            lyrics = item.stringValue ?? "가사 없음"
        default:
            print("\(item.commonKey?.rawValue): \(item.stringValue)")
        }
    }
//    return music
}
