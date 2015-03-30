//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/24/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemesCollectionCell"

class SentMemesCollectionViewController: UICollectionViewController, UICollectionViewDataSource, UICollectionViewDelegate {
    
    private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    private var memes: [Meme]?
    
    // MARK: View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.memes = appDelegate.memes
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.memes = appDelegate.memes
        self.collectionView?.reloadData()
    }
    
    // MARK: IBActions
    
    @IBAction func presentMemeEditor(sender: AnyObject) {
        let memeEditorNav = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNav") as UINavigationController
        self.navigationController!.presentViewController(memeEditorNav, animated: true, completion: nil)
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.memes!.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as SentMemesCollectionViewCell
    
        // Configure the cell
        cell.memeImageView.image = self.memes![indexPath.row].memedImage
        
        return cell
    }

    // MARK: UICollectionViewDelegate

    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Create the detail view controller
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController

        // Set the index of the selected table view entry
        detailViewController.memeIndex = indexPath.row
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
}
