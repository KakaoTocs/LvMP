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
    private var playlist: [String] = []
    
    func play() {
        self.audioPlayer.play()
    }
    
    func pasue() {
        self.audioPlayer.pause()
    }
    
    func stop() {
        self.audioPlayer.stop()
    }
    
    func appendList(url: String) {
        self.playlist.append(url)
    }
    
    func removeList(at index: Int) {
        self.playlist.remove(at: index)
    }
    
    func changeOrder(at: Int, to: Int) {
        let a = self.playlist[at]
        self.playlist[at] = self.playlist[to]
        self.playlist[to] = a
    }
    
    
}
