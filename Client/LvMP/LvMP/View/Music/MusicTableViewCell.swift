//
//  MusicsTableViewCell.swift
//  LvMP
//
//  Created by Jinu Kim on 16/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit

class MusicTableViewCell: UITableViewCell {
    
    static let identifier = "MusicTableViewCell"

    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var playtimeLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    let imageMaskView: UIImageView = {
        let maskView = UIImageView()
        maskView.image = UIImage(named: "Mask.png")
        return maskView
    }()
    
    func refresh(with music: Music) {
        self.titleLabel.text = music.title
        self.artistLabel.text = music.artist?.name
        self.playtimeLabel.text = music.playtimeString
        self.artworkImageView.image = music.getArtworkImage()
        self.artworkImageView.mask = self.imageMaskView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageMaskView.frame = self.artworkImageView.bounds
    }
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
