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
    @IBOutlet weak var memeImage: UIImage?
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.imageView.image = memeImage!
    }


    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        // Get the new view controller using segue.destinationViewController.
        // Pass the selected object to the new view controller.
    }
    */

}
