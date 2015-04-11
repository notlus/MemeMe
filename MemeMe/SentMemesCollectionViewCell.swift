//
//  SentMemesCollectionViewCell.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/24/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

protocol SentMemesCollectionCellDelegate {
    func deleteMemeForCell(cell: SentMemesCollectionViewCell)
}

class SentMemesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    var index: Int?
    
    var delegate: SentMemesCollectionCellDelegate?
    
    override func awakeFromNib() {
        super.awakeFromNib()
        selected = false
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        if let delegate = self.delegate {
            delegate.deleteMemeForCell(self)
        }
    }
}
