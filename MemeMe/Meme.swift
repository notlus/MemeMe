//
//  Meme.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/22/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

/// Represents a single meme
struct Meme {
    var topText: String
    var bottomText: String
    var sourceImage: UIImage
    var memedImage: UIImage

    /// Intializer for the `Meme` struct
    init(top topText: String, bottom bottomText: String, source sourceImage: UIImage, memed memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.sourceImage = sourceImage
        self.memedImage = memedImage
    }
}
