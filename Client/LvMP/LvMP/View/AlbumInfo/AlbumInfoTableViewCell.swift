//
//  AlbumInfoTableViewCell.swift
//  LvMP
//
//  Created by Jinu Kim on 18/10/2018.
//  Copyright © 2018 Jinu Kim. All rights reserved.
//

import UIKit

class AlbumInfoTableViewCell: UITableViewCell {
    
    static let identifier = "AblumInfoTableViewCell"

    @IBOutlet weak var trackNumberLabel: UILabel!
    @IBOutlet weak var titleLabel: UILabel!
    @IBOutlet weak var playtimeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(_ selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }

}
