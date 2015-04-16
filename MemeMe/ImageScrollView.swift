//
//  MemeScrollView.swift
//  ImageExperiment
//
//  Created by Jeffrey Sulton on 4/16/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

/// Adapted from the NYTScalingImageView class: https://github.com/NYTimes/NYTPhotoViewer
class ImageScrollView: UIScrollView {

    @IBOutlet weak var imageView: UIImageView!
    
    required init(coder aDecoder: NSCoder) {
        super.init(coder: aDecoder)
    }

    func setImage(image: UIImage) {
        imageView.image = image
        contentSize = image.size
        updateZoomScale()
        centerContent()
    }
    
    private func updateZoomScale() {
        if let image = imageView.image {
            let scrollViewFrame = bounds;
            
            let scaleWidth: CGFloat = scrollViewFrame.size.width / image.size.width;
            let scaleHeight: CGFloat = scrollViewFrame.size.height / image.size.height;
            let minScale = fmin(scaleWidth, scaleHeight);
            
            self.minimumZoomScale = minScale;
            self.maximumZoomScale = 1.0;
            
            self.zoomScale = self.minimumZoomScale;
        }
    }
    
    private func centerContent() {
        var horizontalInset: CGFloat = 0;
        var verticalInset: CGFloat = 0;
        
        if (self.contentSize.width < CGRectGetWidth(bounds)) {
            horizontalInset = (CGRectGetWidth(bounds) - contentSize.width) * 0.5;
        }
        
        if (self.contentSize.height < CGRectGetHeight(bounds)) {
            verticalInset = (CGRectGetHeight(bounds) - contentSize.height) * 0.5;
        }
        
        // Use `contentInset` to center the contents in the scroll view. Reasoning explained here: http://petersteinberger.com/blog/2013/how-to-center-uiscrollview/
        self.contentInset = UIEdgeInsetsMake(verticalInset, horizontalInset, verticalInset, horizontalInset);
    }
}
