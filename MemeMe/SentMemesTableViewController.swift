//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/22/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    // MARK: Outlets
    @IBOutlet weak var editButton: UIBarButtonItem!

    private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    private var selectedIndex: Int?
    private var showMemeEditor = true
    
    // MARK: View Management
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.editButton.enabled = !appDelegate.memes.isEmpty
        self.tableView?.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if self.showMemeEditor && appDelegate.memes.isEmpty {
            // Show the meme editor
            self.presentMemeEditor(self)
            self.showMemeEditor = false
        }
    }
    
    // MARK: IBActions
    
    @IBAction func presentMemeEditor(sender: AnyObject) {
        let memeEditor = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as MemeEditorViewController
        self.navigationController!.presentViewController(memeEditor, animated: true, completion: nil)
    }
    
    @IBAction func editMeme(sender: AnyObject) {
        self.editing = !self.editing
        
        if editing {
            self.editButton.title = "Cancel"
        }
        else {
            self.editButton.title = "Edit"
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("SentMemesCell") as SentMemesTableViewCell
        var meme = appDelegate.memes[indexPath.row]
        cell.memeImageView!.image = meme.memedImage
        cell.topMemeLabel.text = meme.topText
        cell.bottomMemeLabel.text = meme.bottomText
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        println("commitEditingStyle")
        appDelegate.memes.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
        // No longer in editing mode
        self.setEditing(false, animated: true)
        
        // Restore the edit button
        self.editButton.title = "Edit"
        self.editButton.enabled = !self.appDelegate.memes.isEmpty
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected row \(indexPath.row)")
        self.selectedIndex = indexPath.row
        
        // Create the detail view controller
        let detailViewController = self.storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController
        
        // Set the index of the selected table view entry
        detailViewController.memeIndex = indexPath.row
        
        self.navigationController!.pushViewController(detailViewController, animated: true)
    }
}
