//
//  Meme.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/22/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

class Meme: Equatable {
    var topText: String
    var bottomText: String
    var sourceImage: UIImage
    var memedImage: UIImage
    
    init(top topText: String, bottom bottomText: String, source sourceImage: UIImage, memed memedImage: UIImage) {
        self.topText = topText
        self.bottomText = bottomText
        self.sourceImage = sourceImage
        self.memedImage = memedImage
    }
}

/// A global `==` operator to determine whether two `Meme` instances refer to the same object
func ==(lhs: Meme, rhs: Meme) -> Bool {
    return ObjectIdentifier(lhs) == ObjectIdentifier(rhs)
}
