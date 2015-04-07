//
//  SentMemesCollectionViewController.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/24/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

private let reuseIdentifier = "SentMemesCollectionCell"

class SentMemesCollectionViewController:
UICollectionViewController,
UICollectionViewDelegateFlowLayout {
    // MARK: Outlets
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    
    // An array to hold the indices of memes that should be deleted
    private var deletionIndices = [NSIndexPath]()
    
    private var editMode: Bool = false {
        didSet {
            println("editMode = \(editMode)")
            collectionView?.allowsMultipleSelection = editMode
            collectionView?.selectItemAtIndexPath(nil, animated: true, scrollPosition: .None)
            
            // Clear out any previous data
            deletionIndices.removeAll(keepCapacity: false)
        }
    }
    
    // MARK: View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false
    }

    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.collectionView?.reloadData()
        
        self.editButton.enabled = !self.appDelegate.memes.isEmpty
    }
    
    // MARK: IBActions
    
    @IBAction func presentMemeEditor(sender: AnyObject) {
        let memeEditor = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as MemeEditorViewController
        self.navigationController!.presentViewController(memeEditor, animated: true, completion: nil)
    }
    
    @IBAction func editMeme(sender: AnyObject) {
        if appDelegate.memes.isEmpty {
            return
        }
        
        self.editMode = !self.editMode
        
        if !deletionIndices.isEmpty {
            // Delete these entries
            println("Deleting memes...")
            
            collectionView?.reloadData()
        }
        
        if self.editMode {
            self.editButton.title = "Delete"
            self.addButton.enabled = false
//            collectionView?.allowsMultipleSelection = true
        }
        else {
            self.editButton.title = "Edit"
            self.addButton.enabled = true
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appDelegate.memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as SentMemesCollectionViewCell
    
        // Configure the cell
        cell.memeImageView.image = self.appDelegate.memes[indexPath.row].memedImage
        
//        if editMode {
//            cell.backgroundColor = UIColor.redColor()
//        }
//        else {
//            cell.backgroundColor = UIColor.blackColor()
//        }
        
//        cell.selected = true;
        
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, shouldSelectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }

    override func collectionView(collectionView: UICollectionView, shouldDeselectItemAtIndexPath indexPath: NSIndexPath) -> Bool {
        return true
    }
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        if editMode {
            // Add the index path to the array of memes to delete
            deletionIndices.append(indexPath)
            println("Added index \(indexPath.row) to memes to delete, count=\(countElements(deletionIndices))")
            collectionView.reloadItemsAtIndexPaths([indexPath])
        }
        else {
            // Create the detail view controller
            let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController

            // Set the index of the selected table view entry
            detailViewController.memeIndex = indexPath.row
            self.navigationController!.pushViewController(detailViewController, animated: true)
        }
    }
    
//    override func collectionView(collectionView: UICollectionView, didDeselectItemAtIndexPath indexPath: NSIndexPath) {
    override func collectionView(collectionView: UICollectionView,
        didDeselectItemAtIndexPath indexPath: NSIndexPath) {
        if editMode {
            // Remove the index path from the array of memes to delete
            if let findIndex = find(deletionIndices, indexPath) {
                println("Removing index \(indexPath.row) from memes to delete")
                deletionIndices.removeAtIndex(findIndex)
            }
        }
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        let size = CGSizeMake(120, 120)
        return size
    }
    
    private let insets = UIEdgeInsets(top: 20, left: 5, bottom: 20, right: 5)
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return insets
    }
}
