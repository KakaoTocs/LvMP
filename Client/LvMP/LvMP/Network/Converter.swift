//
//  Converter.swift
//  LvMP
//
//  Created by Jinu Kim on 04/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import AVFoundation


func fileToMusic(at: URL) {
    print(at)
    let musicFile = AVPlayerItem(url: at)
    let metaData = musicFile.asset.metadata
    
    var title = "제목 없음"
    var artist = "아티스트 없음"
    var albumName = "앨범명 없음"
    var lyrics = "가사 없음"
    var artwork = Data()
    
    for item in metaData {
        switch item.commonKey?.rawValue {
        case "title":
            if let titleValue = item.stringValue {
                title = titleValue
            }
        case "artist":
            if let artistValue = item.stringValue {
                artist = artistValue
            }
        case "albumName":
            if let albumNameValue = item.stringValue {
                albumName = albumNameValue
            }
        case "artwork":
            if let artworkValue = item.dataValue {
                artwork = artworkValue
            }
        case "ko":
            if let lyricsValue = item.stringValue {
                lyrics = lyricsValue
            }
        default:
            print("\(item.commonKey?.rawValue): \(item.stringValue)")
        }
    }
    
    do {
        let audioPlayer = try AVAudioPlayer(contentsOf: url)
        playTime = UInt64(audioPlayer.duration)
        fileData = try Data(contentsOf: url)
    } catch {
        playTime = 0
        if fileData == nil {
            return nil
        }
    }
    
    print(title)
    print(artist)
    print(albumName)
    print(lyrics)
//    return music
}
