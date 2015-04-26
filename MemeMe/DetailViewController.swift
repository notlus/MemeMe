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
    
    /// Index in the model of the meme this view controller should display. This is set by the
    /// sending view controller
    var memeIndex = 0
    
    /// The meme model is in the app delegate
    private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Create the edit button
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme")
        var rightButtons = navigationItem.rightBarButtonItems! as [UIBarButtonItem]
        rightButtons.append(editButton)
        navigationItem.rightBarButtonItems = rightButtons
    }
    
    override func viewWillAppear(animated: Bool) {
        // Get the image for the selected meme from the model
        imageView.image = appDelegate.memes[memeIndex].memedImage
    }

    func editMeme() {
        let memeEditor = storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as MemeEditorViewController
        
        memeEditor.memeIndex = memeIndex
        presentViewController(memeEditor, animated: true, completion: nil)
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        appDelegate.memes.removeAtIndex(memeIndex)
        navigationController?.popViewControllerAnimated(true)
    }
}
