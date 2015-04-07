//
//  SentMemesCollectionViewCell.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/24/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

class SentMemesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selected = false
    }
    
    override var selected: Bool {
        didSet {
            self.backgroundColor = selected ? UIColor.redColor() : UIColor.blackColor()
        }
    }
}
