//
//  ListTableViewCell.swift
//  AudioPlayer
//
//  Created by DGSW_TEACHER on 2016. 11. 23..
//  Copyright © 2016년 dgsw. All rights reserved.
//

import UIKit

class ListTableViewCell: UITableViewCell {

    @IBOutlet weak var MusicTitle: UILabel!
    @IBOutlet weak var MusicSinger: UILabel!
    @IBOutlet weak var MusicWork: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
