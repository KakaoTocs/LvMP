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
    
    for item in metaData {
        switch item.commonKey?.rawValue {
        case "title":
            print("Title: \(item.stringValue)")
        case "artist":
            print("Artist: \(item.stringValue)")
        case "albumName":
            print("albumName: \(item.stringValue)")
        case "artwork":
            print("Artwork")
        case "ko":
            print("lyric: \(item.stringValue)")
        default:
            print("\(item.commonKey?.rawValue): \(item.stringValue)")
        }
    }
//    return music
}
