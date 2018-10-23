//
//  ArtistTableViewCell.swift
//  LvMP
//
//  Created by Jinu Kim on 16/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit

class ArtistTableViewCell: UITableViewCell {
    
    static let identifier = "ArtistTableViewCell"

    @IBOutlet weak var profileImageView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var albumCountLabel: UILabel!
    @IBOutlet weak var musicCountLabel: UILabel!
    @IBOutlet weak var playtimeLabel: UILabel!
    
    let imageMaskView: UIImageView = {
        let maskView = UIImageView()
        maskView.image = UIImage(named: "Mask.png")
        return maskView
    }()
    
    override func layoutSubviews() {
        super.layoutSubviews()
        
        imageMaskView.frame = self.profileImageView.bounds
    }
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
