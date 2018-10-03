//
//  PlayListTableViewCell.swift
//  AudioPlayer
//
//  Created by DGSW_TEACHER on 2016. 12. 2..
//  Copyright © 2016년 dgsw. All rights reserved.
//

import UIKit

class PlayListTableViewCell: UITableViewCell {

    @IBOutlet weak var PlayListTitle: UILabel!
    @IBOutlet weak var PlayListImage: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
