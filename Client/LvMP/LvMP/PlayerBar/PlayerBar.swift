//
//  PlayerBar.swift
//  LvMP
//
//  Created by Jinu Kim on 27/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit
import AVFoundation

class PlayerBar: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    @IBOutlet weak var totalProgressView: UIView!
    @IBOutlet weak var currentProgressView: UIView!
    @IBOutlet weak var currentProgressViewWidthConstraint: NSLayoutConstraint!
    
    var player = Player.shared
    
    override init(frame: CGRect) {
        super.init(frame: frame)
        commonInit()
    }
    
    required init?(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
        commonInit()
    }
    
    private func commonInit() {
        Bundle.main.loadNibNamed("PlayerBar", owner: self, options: nil)
        addSubview(contentView)
        contentView.frame = self.bounds
        contentView.autoresizingMask = [.flexibleHeight, .flexibleWidth]
        player.delegate = self
        currentProgressViewWidthConstraint.constant = 0
    }
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        if sender.isSelected {
            player.pasue()
        } else {
            player.play()
        }
    }
    
}

extension PlayerBar: PlayerDelegate {
    func currentMusicChanged() {
        self.artworkImageView.image = self.player.currentMusic?.getArtworkImage()
        self.titleLabel.text = self.player.currentMusic?.title
    }
    
    func playStateChanged(state: Player.State) {
        switch state {
        case .play:
            self.playButton.isSelected = true
            break
        case .pause:
            self.playButton.isSelected = false
            break
        case .stop:
            self.playButton.isSelected = false
            break
        }
    }
    
    func currentTimeUpdated(current: Int) {
        if current == 0 {
            currentProgressViewWidthConstraint.constant = CGFloat(0)
            return
        }
        let width = Float(totalProgressView.frame.width) * (Float(current) / Float(self.player.currentMusic!.playtime))
        print("\(width)")
        currentProgressViewWidthConstraint.constant = CGFloat(width)
    }
    
    func playerBarClear() {
        
    }
}
