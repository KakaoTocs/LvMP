//
//  AlbumInfoTableViewHeader.swift
//  LvMP
//
//  Created by Jinu Kim on 18/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit

class AlbumInfoTableViewHeader: UITableViewCell {

    static let identifier = "AblumInfoTableViewHeader"
    
    @IBOutlet weak var artworkImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var yearLabel: UILabel!
    
    let imageMaskView: UIImageView = {
        let maskView = UIImageView()
        maskView.image = UIImage(named: "Mask.png")
        return maskView
    }()
    
    func refresh(with album: Album) {
        self.layoutSubviews()
        self.contentView.layoutSubviews()
        
        self.artworkImageView.image = album.musics.first?.getArtworkImage()
        self.artworkImageView.mask = self.imageMaskView
        self.nameLabel.text = album.name
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
