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
UICollectionViewDelegateFlowLayout,
SentMemesCollectionCellDelegate {
    
    // MARK: Outlets
    
    @IBOutlet weak var editButton: UIBarButtonItem!
    @IBOutlet weak var addButton: UIBarButtonItem!
    
    private let appDelegate = UIApplication.sharedApplication().delegate as! AppDelegate
    
    // An array to hold the indices of memes that should be deleted
    private var deletionIndices = [Meme]()
    
    private var editMode: Bool = false {
        didSet {
            println("editMode = \(editMode)")
            collectionView?.allowsMultipleSelection = editMode
            collectionView?.selectItemAtIndexPath(nil, animated: true, scrollPosition: .None)
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
        let memeEditor = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as! MemeEditorViewController
        self.navigationController!.presentViewController(memeEditor, animated: true, completion: nil)
    }
    
    @IBAction func editMeme(sender: AnyObject) {
        
        editMode = !editMode
        
        toggleDeleteButton(editMode)

        if self.editMode {
            editButton.title = "Done"
            addButton.enabled = false
        }
        else {
            self.editButton.title = "Edit"
            self.addButton.enabled = true
        }
    }
    
    private func toggleDeleteButton(show: Bool) {
        for var i = 0; i < appDelegate.memes.count; ++i {
            let indexPath = NSIndexPath(forRow: i, inSection: 0)
            let cell = collectionView?.cellForItemAtIndexPath(indexPath) as! SentMemesCollectionViewCell
            cell.deleteButton.hidden = !show
        }
    }
    
    // MARK: UICollectionViewDataSource

    override func collectionView(collectionView: UICollectionView, numberOfItemsInSection section: Int) -> Int {
        return self.appDelegate.memes.count
    }

    override func collectionView(collectionView: UICollectionView, cellForItemAtIndexPath indexPath: NSIndexPath) -> UICollectionViewCell {
        let cell = collectionView.dequeueReusableCellWithReuseIdentifier(reuseIdentifier, forIndexPath: indexPath) as! SentMemesCollectionViewCell
    
        // Configure the cell
        cell.memeImageView.image = self.appDelegate.memes[indexPath.row].memedImage
        cell.backgroundColor = UIColor.blackColor()
        cell.delegate = self
        cell.deleteButton.hidden = editMode ? false : true
       
        return cell
    }

    // MARK: UICollectionViewDelegate
    
    override func collectionView(collectionView: UICollectionView, didSelectItemAtIndexPath indexPath: NSIndexPath) {
        // Create the detail view controller
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as! DetailViewController

        // Set the index of the selected table view entry
        detailViewController.memeIndex = indexPath.row
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
    
    // MARK: UICollectionViewDelegateFlowLayout
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, sizeForItemAtIndexPath indexPath: NSIndexPath) -> CGSize {
        return CGSizeMake(105, 105)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, insetForSectionAtIndex section: Int) -> UIEdgeInsets {
        return UIEdgeInsets(top: 0, left: 0, bottom: 0, right: 0)
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumInteritemSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
    
    func collectionView(collectionView: UICollectionView, layout collectionViewLayout: UICollectionViewLayout, minimumLineSpacingForSectionAtIndex section: Int) -> CGFloat {
        return 2.0
    }
    
    // MARK: SentMemesCollectionCellDelegate
    
    func deleteMemeForCell(cell: SentMemesCollectionViewCell) {
        // Get the index path for the cell provided
        if let indexPath = collectionView?.indexPathForCell(cell) {
            println("Deleting meme at index \(indexPath.row)")
            appDelegate.memes.removeAtIndex(indexPath.row)
            collectionView?.reloadData()
        }
    }
}
