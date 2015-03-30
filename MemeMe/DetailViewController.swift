//
//  DetailViewController.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/23/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

class DetailViewController: UIViewController {
    @IBOutlet weak var imageView: UIImageView!
    
    // Index in the model of the meme this view controller should display. This is set by the 
    // sending view controller
    var memeIndex = 0
    
    // The meme model is in the app delegate
    private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Get the image for the selected meme from the model
        self.imageView.image = self.appDelegate.memes[self.memeIndex].memedImage
    }

    @IBAction func deleteMeme(sender: AnyObject) {
        self.appDelegate.memes.removeAtIndex(self.memeIndex)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
