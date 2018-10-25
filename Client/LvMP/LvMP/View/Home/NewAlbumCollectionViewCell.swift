//
//  NewAlbumCollectionViewCell.swift
//  LvMP
//
//  Created by Jinu Kim on 16/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit

class NewAlbumCollectionViewCell: UICollectionViewCell {
    
    static let identifier = "NewAlbumCollectionViewCell"
    
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var artistLabel: UILabel!
    @IBOutlet weak var artworkImageView: UIImageView!
    
    let imageMaskView: UIImageView = {
        let maskView = UIImageView()
        maskView.image = UIImage(named: "Mask.png")
        return maskView
    }()
    
    func refresh(with album: Album) {
        self.layoutSubviews()
        self.contentView.layoutSubviews()
        
        self.nameLabel.text = album.name
        self.artistLabel.text = album.artist?.name
        self.artworkImageView.image = album.musics.first?.getArtworkImage()
        self.artworkImageView.mask = self.imageMaskView
    }
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageMaskView.frame = self.artworkImageView.bounds
    }
}
