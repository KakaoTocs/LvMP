//
//  PlayerBar.swift
//  LvMP
//
//  Created by Jinu Kim on 27/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit

class PlayerBar: UIView {

    @IBOutlet var contentView: UIView!
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playButton: UIButton!
    
    var player = Player()
    
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
    }
    
    @IBAction func playButtonAction(_ sender: UIButton) {
        player.toggle()
    }
    
}
