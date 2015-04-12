//
//  SentMemesTableViewCell.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/28/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

/// Represents a cell in the SentMemesTableViewController
class SentMemesTableViewCell: UITableViewCell {

    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var topMemeLabel: UILabel!
    @IBOutlet weak var bottomMemeLabel: UILabel!
    
    override func awakeFromNib() {
        super.awakeFromNib()
    }

    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)
    }
}
