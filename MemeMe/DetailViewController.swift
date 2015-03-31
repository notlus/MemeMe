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

        // Create the edit button
        let editButton = UIBarButtonItem(barButtonSystemItem: UIBarButtonSystemItem.Edit, target: self, action: "editMeme")
        var rightButtons = self.navigationItem.rightBarButtonItems! as [UIBarButtonItem]
        rightButtons.append(editButton)
        self.navigationItem.rightBarButtonItems = rightButtons
    }
    
    override func viewWillAppear(animated: Bool) {
        // Get the image for the selected meme from the model
        self.imageView.image = self.appDelegate.memes[self.memeIndex].memedImage
    }

    func editMeme() {
        let memeEditorNav = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNav") as UINavigationController
        
        // The meme editor is the root view controller
        let memeEditor = memeEditorNav.viewControllers.first as MemeEditorViewController
        memeEditor.memeIndex = self.memeIndex
        self.navigationController?.presentViewController(memeEditorNav, animated: true, completion: nil)
    }
    
    @IBAction func deleteMeme(sender: AnyObject) {
        self.appDelegate.memes.removeAtIndex(self.memeIndex)
        self.navigationController?.popViewControllerAnimated(true)
    }
}
