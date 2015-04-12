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
        editButton.enabled = !appDelegate.memes.isEmpty
        tableView?.reloadData()
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if showMemeEditor && appDelegate.memes.isEmpty {
            // Show the meme editor
            presentMemeEditor(self)
            showMemeEditor = false
        }
    }
    
    // MARK: IBActions
    
    @IBAction func presentMemeEditor(sender: AnyObject) {
        let memeEditor = storyboard?.instantiateViewControllerWithIdentifier("MemeEditor") as MemeEditorViewController
        navigationController!.presentViewController(memeEditor, animated: true, completion: nil)
    }
    
    @IBAction func editMeme(sender: AnyObject) {
        setEditing(!editing, animated: true)

        if editing {
            editButton.title = "Cancel"
        }
        else {
            editButton.title = "Edit"
        }
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return appDelegate.memes.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = tableView.dequeueReusableCellWithIdentifier("SentMemesCell") as SentMemesTableViewCell
        var meme = appDelegate.memes[indexPath.row]
        cell.memeImageView!.image = meme.memedImage
        cell.topMemeLabel.text = meme.topText
        cell.bottomMemeLabel.text = meme.bottomText
        return cell
    }
    
    override func tableView(tableView: UITableView, commitEditingStyle editingStyle: UITableViewCellEditingStyle, forRowAtIndexPath indexPath: NSIndexPath) {
        appDelegate.memes.removeAtIndex(indexPath.row)
        tableView.deleteRowsAtIndexPaths([indexPath], withRowAnimation: UITableViewRowAnimation.Fade)
        
        // No longer in editing mode
        setEditing(false, animated: true)
        
        // Restore the edit button
        editButton.title = "Edit"
        editButton.enabled = !appDelegate.memes.isEmpty
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected row \(indexPath.row)")
        selectedIndex = indexPath.row
        
        // Create the detail view controller
        let detailViewController = storyboard!.instantiateViewControllerWithIdentifier("DetailViewController")! as DetailViewController
        
        // Set the index of the selected table view entry
        detailViewController.memeIndex = indexPath.row
        
        navigationController!.pushViewController(detailViewController, animated: true)
    }
}
