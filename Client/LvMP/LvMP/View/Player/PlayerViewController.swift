//
//  PlayerViewController.swift
//  LvMP
//
//  Created by Jinu Kim on 03/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit

class PlayerViewController: UIViewController {

    @IBOutlet weak var backgroundImageView: UIImageView!
    @IBOutlet weak var backgroundImageEffectView: UIVisualEffectView!
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var currentTimeProgressbar: UIProgressView!
    @IBOutlet weak var currentTimeLabel: UILabel!
    @IBOutlet weak var totalTimeLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var infoLabel: UILabel!
    
    let imageMaskView: UIImageView = {
        let maskView = UIImageView()
        maskView.image = UIImage(named: "Mask.png")
        return maskView
    }()
    
    override func viewDidLoad() {
        super.viewDidLoad()
        refreshData()
        Player.shared.delegate = self
    }
    
    @IBAction func backButtonAction(_ sender: UIButton) {
        self.dismiss(animated: true, completion: nil)
    }
    
    private func refreshData() {
        guard let music = Player.shared.currentMusic else {
            return
        }
        self.artworkImageView.layoutSubviews()
        self.backgroundImageView.image = music.getArtworkImage()
        self.artworkImageView.image = music.getArtworkImage()
        self.imageMaskView.frame = self.artworkImageView.bounds
        self.artworkImageView.mask = self.imageMaskView
        self.titleLabel.text = music.title
        self.infoLabel.text = "\(music.artist!.name) - \(music.album!.name)"
        self.totalTimeLabel.text = String(format: "%02d:%02d", (music.playtime  / 60), (music.playtime % 60))
        let currentTime = Player.shared.currentTime()
        self.currentTimeLabel.text = String(format: "%02d:%02d", (currentTime  / 60), (currentTime % 60))
        self.currentTimeProgressbar.progress = Float(currentTime) / Float(music.playtime)
    }
}

extension PlayerViewController: PlayerDelegate {
    func currentMusicChanged() {
        refreshData()
    }
    
    func playStateChanged(state: Player.State) {
//        switch state {
//        case .play:
//            self
//        case .pause:
//        case .stop:
//        }
    }
    
    func currentTimeUpdated(current time: Int) {
        self.currentTimeLabel.text = String(format: "%02d:%02d", (time / 60), (time % 60))
        guard let music = Player.shared.currentMusic else {
            return
        }
        self.currentTimeProgressbar.progress = Float(music.playtime) / Float(time)
    }
}
