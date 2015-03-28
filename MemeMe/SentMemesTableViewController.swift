//
//  SentMemesTableViewController.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/22/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

class SentMemesTableViewController: UITableViewController {

    private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
    private var memes: [Meme]?
    private var selectedIndex: Int?
    private var showMemeEditor = true
    
    // MARK: View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        // TODO: Try removing
        self.tableView.contentInset = UIEdgeInsetsMake(64,0,0,0);

        // Initialize the memes array from the model
        self.memes = appDelegate.memes
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.memes = appDelegate.memes
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if self.showMemeEditor && self.memes!.isEmpty {
            // Show the meme editor
            self.presentMemeEditor(self)
            self.showMemeEditor = false
        }
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        let detailViewController = segue.destinationViewController as DetailViewController
        detailViewController.memeImage = self.memes![selectedIndex!].memedImage
    }
    
    // MARK: IBActions
    
    @IBAction func presentMemeEditor(sender: AnyObject) {
        let memeEditorNav = self.storyboard?.instantiateViewControllerWithIdentifier("MemeEditorNav") as UINavigationController
        self.navigationController!.presentViewController(memeEditorNav, animated: true, completion: nil)
    }
    
    // MARK: UITableViewDataSource
    
    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return self.memes!.count
    }
    
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        var cell = self.tableView.dequeueReusableCellWithIdentifier("SentMemesCell") as UITableViewCell
        var meme = self.memes![indexPath.row]
        cell.textLabel!.text = meme.topText
        cell.imageView!.image = meme.memedImage
        return cell
    }
    
    // MARK: UITableViewDelegate
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        println("selected row \(indexPath.row)")
        self.selectedIndex = indexPath.row
        self.performSegueWithIdentifier("ShowDetailView", sender: self)
    }
}

