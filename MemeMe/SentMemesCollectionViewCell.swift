//
//  SentMemesCollectionViewCell.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/24/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

/// Protocol that defines a function that can be used to delete a cell from the 
/// SentMemesCollectionViewController
protocol SentMemesCollectionCellDelegate {
    func deleteMemeForCell(cell: SentMemesCollectionViewCell)
}

/// Represents a cell in the SentMemesCollectionViewController
class SentMemesCollectionViewCell: UICollectionViewCell {
    @IBOutlet weak var memeImageView: UIImageView!
    @IBOutlet weak var deleteButton: UIButton!
    
    /// Optional SentMemesCollectionCellDelegate
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
