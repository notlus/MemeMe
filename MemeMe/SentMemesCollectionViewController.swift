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

    var memes: [Meme]?
    var selectedIndex: Int?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
        self.memes = appDelegate.memes
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
//    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using [segue destinationViewController].
        // Pass the selected object to the new view controller.
//        let detailViewController = segue.destinationViewController as DetailViewController
//        detailViewController.memeImage = self.memes![self.selectedIndex!].memedImage
//    }

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
//        self.selectedIndex = indexPath.row
        
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController
        detailViewController.memeImage = self.memes![indexPath.row].memedImage
        self.navigationController!.pushViewController(detailViewController, animated: true)
        
        
//        self.navigationController?.presentViewController(detailViewController, animated: true, completion: nil)
        
//        self.performSegueWithIdentifier("ShowDetailView", sender: self)
    }
}
