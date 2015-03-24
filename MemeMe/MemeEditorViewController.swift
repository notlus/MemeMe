//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/22/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {

    // MARK: - Outlets
    
    @IBOutlet weak var topTextButton: UITextField!
    @IBOutlet weak var bottomTextButton: UITextField!
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    
//    var memedImage: UIImage?
    
    // MARK: - Text Field Data
    
    let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "HelveticaNeue-CondensedBlack", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]
    
    let topDefaultText = "TOP"
    let bottomDefaultText = "BOTTOM"
    
    enum TextType: Int {
        case Top = 0
        case Bottom = 1
    }

    // MARK: - View Management
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shareButton.enabled = false
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.initializeTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        super.viewWillDisappear(animated)
        self.unsubscribeFromKeyboardNotifications()
    }

    // MARK: - Navigation
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        println("Preparing for segue")
        let sentMemesViewController = segue.destinationViewController as UITabBarController
    }
    
    // MARK: - Actions
    
    @IBAction func chooseImageFromCamera(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.delegate = self
        imagePicker.sourceType = UIImagePickerControllerSourceType.Camera
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func chooseImageFromLibrary(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        self.presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func shareMeme(sender: AnyObject) {
        // Create the Meme instance
        let memedImage = self.generateMemedImage()
        let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        activityView.completionHandler = {(activityType, completed: Bool) in
            println("Done with activity, completed=\(completed)")
            if completed {
                let meme = Meme(top: self.topTextButton.text, bottom: self.bottomTextButton.text, source: self.sourceImageView.image!, memed: memedImage)
                let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate
                appDelegate.memes.append(meme)
                self.dismissViewControllerAnimated(true, completion: nil)
                self.performSegueWithIdentifier("SentMemesSegue", sender: self)
            }
        }
        
        self.presentViewController(activityView, animated: true, completion: nil)
    }
    
    // TODO: Implement
    @IBAction func cancel(sender: AnyObject) {
    }
    
    // MARK: - Helpers
    
    func initializeTextFields() {
        self.topTextButton.text = self.topDefaultText
        self.topTextButton.delegate = self
        self.topTextButton.defaultTextAttributes = self.memeTextAttributes
        self.topTextButton.textAlignment = NSTextAlignment.Center
        self.topTextButton.tag = TextType.Top.rawValue

        self.bottomTextButton.text = self.bottomDefaultText
        self.bottomTextButton.delegate = self
        self.bottomTextButton.defaultTextAttributes = self.memeTextAttributes
        self.bottomTextButton.textAlignment = NSTextAlignment.Center
        self.bottomTextButton.tag = TextType.Bottom.rawValue
    }
    
    // TODO: Fix so that it does not include the toolbar and nav bar
    func generateMemedImage() -> UIImage {
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let context = UIGraphicsGetCurrentContext()
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        return memedImage
    }

    func subscribeToKeyboardNotifications() {
        println("subscribeToKeyboardNotifications")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    func unsubscribeFromKeyboardNotifications() {
        println("unsubscribeFromKeyboardNotifications")
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillShowNotification)
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillHideNotification)
    }
    
    func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let value = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        return value.CGRectValue().size.height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if self.bottomTextButton.isFirstResponder() {
            println("willShow....")
            // Subtract the height of the keyboard from the y-coordinate of the view
            self.view.frame.origin.y -= getKeyboardHeight(notification)
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.bottomTextButton.isFirstResponder() {
            println("willHide....")
            // Add the height of the keyboard to the y-coordinate of the view
            self.view.frame.origin.y += getKeyboardHeight(notification)
        }
    }
}

extension MemeEditorViewController: UITextFieldDelegate, UINavigationControllerDelegate, UIImagePickerControllerDelegate {

    // MARK:  UITextFieldDelegate

    func textFieldDidBeginEditing(textField: UITextField) {
        textField.text = ""
    }

    func textFieldDidEndEditing(textField: UITextField) {
        if countElements(textField.text) == 0 {
            // Restore the default text
            if textField.tag == TextType.Top.rawValue {
                textField.text = topDefaultText
            }
            else if textField.tag == TextType.Bottom.rawValue {
                textField.text = bottomDefaultText
            }
        }
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        textField.resignFirstResponder()
        return true
    }
    
    // MARK: - UIImagePickerControllerDelegate

    func imagePickerController(picker: UIImagePickerController, didFinishPickingMediaWithInfo info: [NSObject : AnyObject]) {
        if let image = info[UIImagePickerControllerOriginalImage] as? UIImage {
            self.sourceImageView.image = image
            self.shareButton.enabled = true
            self.dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
}
