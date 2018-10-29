//
//  Player.swift
//  LvMP
//
//  Created by Jinu Kim on 18/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import Foundation
import AVFoundation
import RealmSwift

@objc protocol PlayerDelegate: class {
    func currentTimeUpdated(current time: Int)
    func playStateChanged(state: Player.State)
    func currentMusicChanged()
}

class Player: NSObject {
    
    static let BackgroundImageNotificationKey = Notification.Name("backgroundImageUpdate")
    static let shared = Player()
    weak var delegate: PlayerDelegate?
    private var realm: Realm!
    
    var currentMusic: Music?
    private var audioPlayer : AVAudioPlayer?
    private var currentID: String? {
        didSet {
            self.currentMusic = realm.object(ofType: Music.self, forPrimaryKey: self.currentID)
            if let url = self.currentMusic?.url {
                do {
                    audioPlayer = try AVAudioPlayer(contentsOf: URL(string: url)!)
                } catch {
                    print("Error >> Player >> url: String? >> didSet: AudioPlayer init error")
                    if audioPlayer != nil {
                        audioPlayer?.play()
                    }
                    let alert = warringAlert(title: "재생할 수 없습니다.", message: "파일을 찾을 수 없습니다.")
                    UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
                    return
                }
                audioPlayer?.delegate = self
                audioPlayer?.volume = self.value
                NotificationCenter.default.post(name: Player.BackgroundImageNotificationKey, object: nil)
                audioPlayer?.play()
                makeAndFireTimer()
                self.delegate?.playStateChanged(state: .play)
                self.delegate?.currentMusicChanged()
            }
        }
    }
    private var value: Float = 1.0 {
        didSet {
            self.audioPlayer?.volume = self.value
        }
    }
    private var timer: Timer!
    private var musiclist: [String] = []
    
    @objc enum State: Int {
        case play
        case pause
        case stop
    }
//    var isPlaying: Bool {
//        return self.audioPlayer.isPlaying
//    }
    
    override init() {
        super.init()
        realm = try! Realm()
    }
    
    // MARK: - Method
    func play(music id: String) {
        self.audioPlayer?.stop()
        self.currentID = id
        guard let audioPlayer = audioPlayer else {
            return
        }
    }
    
    func play() {
        self.audioPlayer?.play()
        self.delegate?.playStateChanged(state: .play)
        makeAndFireTimer()
    }
    
    func pasue() {
        self.audioPlayer?.pause()
        self.delegate?.playStateChanged(state: .pause)
        invalidateTimer()
    }
    
    func stop() {
        self.audioPlayer?.stop()
        invalidateTimer()
        self.delegate?.playStateChanged(state: .stop)
    }
    
//    func next() {
//        if let musicID = musiclist.first {
//            self.play(music: musicID)
//        } else {
//            self.stop()
//        }
//    }
//
//    func before() {
//
//    }
//
//    func toggle() {
//        // TODO: Optional Unwrapping
//        guard let audioPlayer = self.audioPlayer else {
//            stop()
//            return
//        }
//        if audioPlayer.isPlaying {
//            pause()
//        } else {
//            play()
//        }
//    }
    
    func currentTime() -> Int {
        return Int(self.audioPlayer?.currentTime ?? 0)
    }
    
    private func makeAndFireTimer() {
        self.timer = Timer.scheduledTimer(withTimeInterval: 1, repeats: true, block: { [unowned self]
            (timer: Timer) in
            
            // TODO: progressBar is Tracking -> false
            if false {
                return
            }
            
            guard let audioPlayer = self.audioPlayer else {
                return
            }
            self.delegate?.currentTimeUpdated(current: Int(audioPlayer.currentTime))
        })
        self.timer.fire()
    }
    
    private func invalidateTimer() {
        self.timer.invalidate()
        self.timer = nil
    }
    
    // TODO:- 여러개 음악 추가/삭제 메소드 만들기
//    func appendList(music url: String) {
//        self.musiclist.append(url)
//    }
//
//    func removeList(at index: Int) {
//        self.musiclist.remove(at: index)
//    }
//
//    func changeOrder(at: Int, to: Int) {
//        let a = self.musiclist[at]
//        self.musiclist[at] = self.musiclist[to]
//        self.musiclist[to] = a
//    }
    
}

extension Player: AVAudioPlayerDelegate {
    
    func audioPlayerDecodeErrorDidOccur(_ player: AVAudioPlayer, error: Error?) {
        guard let error: Error = error else {
            print("오디오 플레이어 디코드 오류발생")
            let alert: UIAlertController = UIAlertController(title: "에러", message: "앱을 종료후 다시 실행해 주세요", preferredStyle: UIAlertController.Style.alert)
            let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
            alert.addAction(okAction)
            DispatchQueue.main.async {
                UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
            }
            
            return
        }
        
        let message: String
        message = "오디오 플레이어 오류 발생 \(error.localizedDescription)"
        
        let alert: UIAlertController = UIAlertController(title: "알림", message: message, preferredStyle: UIAlertController.Style.alert)
        let okAction: UIAlertAction = UIAlertAction(title: "확인", style: .cancel, handler: nil)
        
        alert.addAction(okAction)
        DispatchQueue.main.async {
            UIApplication.shared.keyWindow?.rootViewController?.present(alert, animated: true, completion: nil)
        }
    }
    
    func audioPlayerDidFinishPlaying(_ player: AVAudioPlayer, successfully flag: Bool) {
        self.stop()
    }
}
