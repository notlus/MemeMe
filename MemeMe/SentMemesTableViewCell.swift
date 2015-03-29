//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/28/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

class SentMemesTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var memeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        // Initialization code
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }

}
