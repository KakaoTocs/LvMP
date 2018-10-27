//
//  Player.swift
//  LvMP
//
//  Created by Jinu Kim on 18/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation
import AVFoundation

@objc protocol PlayerDelegate: class {
    func playtimeUpdated()
    func platStateChanged()
}

class Player {
    
    static let shared = Player()
    
    var audioPlayer : AVAudioPlayer!
    var url: String? {
        didSet {
            do {
                audioPlayer = try AVAudioPlayer(contentsOf: URL(string: self.url!)!)
            } catch {
                print("Error >> Player >> url: String? >> didSet: AudioPlayer init error")
            }
        }
    }
    var value: Float = 1.0 {
        didSet {
            self.audioPlayer.volume = self.value
        }
    }
    var time: Timer!
    private var musiclist: [String] = []
//    var isPlaying: Bool {
//        return self.audioPlayer.isPlaying
//    }
    
    // MARK: - Method
    func play() {
        self.audioPlayer.play()
    }
    
    func pasue() {
        self.audioPlayer.pause()
    }
    
    func stop() {
        self.audioPlayer.stop()
    }
    
    func toggle() {
        if audioPlayer.isPlaying {
            pause()
        } else {
            play()
        }
    }
    
    // TODO:- 여러개 음악 추가/삭제 메소드 만들기
    func appendList(url: String) {
        self.musiclist.append(url)
    }
    
    func removeList(at index: Int) {
        self.musiclist.remove(at: index)
    }
    
    func changeOrder(at: Int, to: Int) {
        let a = self.musiclist[at]
        self.musiclist[at] = self.musiclist[to]
        self.musiclist[to] = a
    }
    
    
}
