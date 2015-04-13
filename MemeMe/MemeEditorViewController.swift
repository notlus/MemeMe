//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/22/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

/// The view controller for creating and editing memes
class MemeEditorViewController: UIViewController {
    private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

    /// An optional Int representing the index in the model of the `Meme` to be edited
    var memeIndex: Int?
    
    // MARK: - Outlets
    
    @IBOutlet weak var topTextButton: UITextField!
    @IBOutlet weak var bottomTextButton: UITextField!
    @IBOutlet weak var sourceImageView: UIImageView!
    @IBOutlet weak var cameraButton: UIBarButtonItem!
    @IBOutlet weak var shareButton: UIBarButtonItem!
    @IBOutlet weak var cancelButton: UIBarButtonItem!
    @IBOutlet weak var topToolBar: UIToolbar!
    @IBOutlet weak var memeEditorToolBar: UIToolbar!
    
    // MARK: - Text Field Data
    
    private let memeTextAttributes = [
        NSStrokeColorAttributeName : UIColor.blackColor(),
        NSForegroundColorAttributeName : UIColor.whiteColor(),
        NSFontAttributeName : UIFont(name: "Impact", size: 40)!,
        NSStrokeWidthAttributeName : -5.0
    ]
    
    private let topDefaultText = "TOP"
    private let bottomDefaultText = "BOTTOM"
    
    enum TextType: Int {
        case Top = 0
        case Bottom = 1
    }

    // MARK: - View Management
    
    override func prefersStatusBarHidden() -> Bool {
        return true
    }
    
    override func viewDidLoad() {
        super.viewDidLoad()

        shareButton.enabled = false
        cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        initializeTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        println("viewWillAppear")
        super.viewWillAppear(animated)
        subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        println("viewWillDisappear")
        super.viewWillDisappear(animated)
        unsubscribeFromKeyboardNotifications()
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
        presentViewController(imagePicker, animated: true, completion: nil)
    }
    
    @IBAction func chooseImageFromLibrary(sender: AnyObject) {
        let imagePicker = UIImagePickerController()
        imagePicker.sourceType = UIImagePickerControllerSourceType.PhotoLibrary
        imagePicker.delegate = self
        presentViewController(imagePicker, animated: true, completion: nil)
    }

    @IBAction func shareMeme(sender: AnyObject) {
        // Create the final meme image
        let memedImage = generateMemedImage()
        
        // Create the activity UI, providing it with an array containing the single meme image
        let activityView = UIActivityViewController(activityItems: [memedImage], applicationActivities: nil)
        
        // Set the completion handler with a closure that creates a `Meme` instance and stores it in
        // the model
        activityView.completionHandler = {(activityType, completed: Bool) in
            println("Done with activity, completed=\(completed)")
            if completed {
                let meme = Meme(top: self.topTextButton.text, bottom: self.bottomTextButton.text, source: self.sourceImageView.image!, memed: memedImage)
                if let index = self.memeIndex {
                    // Replace an existing meme at index
                    self.appDelegate.memes[index] = meme
                    self.memeIndex = nil
                }
                else {
                    // Create a new meme
                    self.appDelegate.memes.append(meme)
                }
                
                // Dismiss the activity UI
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        presentViewController(activityView, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Helpers
    
    private func initializeTextFields() {
        topTextButton.delegate = self
        topTextButton.defaultTextAttributes = memeTextAttributes
        topTextButton.textAlignment = NSTextAlignment.Center
        topTextButton.tag = TextType.Top.rawValue

        bottomTextButton.delegate = self
        bottomTextButton.defaultTextAttributes = memeTextAttributes
        bottomTextButton.textAlignment = NSTextAlignment.Center
        bottomTextButton.tag = TextType.Bottom.rawValue
        
        if let index = memeIndex {
            topTextButton.text = appDelegate.memes[index].topText
            bottomTextButton.text = appDelegate.memes[index].bottomText
            sourceImageView.image = appDelegate.memes[index].sourceImage
        }
        else {
            topTextButton.text = topDefaultText
            bottomTextButton.text = bottomDefaultText
        }
    }
    
    /// Generates a `UIImage` containing the top and bottom meme text
    private func generateMemedImage() -> UIImage {
        // Hide the top and bottom toolbars before capturing the image
        topToolBar.hidden = true
        memeEditorToolBar.hidden = true
        
        UIGraphicsBeginImageContext(view.frame.size)
        view.drawViewHierarchyInRect(view.frame, afterScreenUpdates: true)
        let context = UIGraphicsGetCurrentContext()
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show the navigation bar and bottom toolbar again
        navigationController?.navigationBar.hidden = false
        topToolBar.hidden = false
        memeEditorToolBar.hidden = false
        
        return memedImage
    }

    private func subscribeToKeyboardNotifications() {
        println("subscribeToKeyboardNotifications")
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillShow:", name: UIKeyboardWillShowNotification, object: nil)
        NSNotificationCenter.defaultCenter().addObserver(self, selector: "keyboardWillHide:", name: UIKeyboardWillHideNotification, object: nil)
    }
    
    private func unsubscribeFromKeyboardNotifications() {
        println("unsubscribeFromKeyboardNotifications")
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillShowNotification)
        NSNotificationCenter.defaultCenter().removeObserver(UIKeyboardWillHideNotification)
    }
    
    private func getKeyboardHeight(notification: NSNotification) -> CGFloat {
        let userInfo = notification.userInfo
        let value = userInfo![UIKeyboardFrameEndUserInfoKey] as NSValue
        return value.CGRectValue().size.height
    }
    
    func keyboardWillShow(notification: NSNotification) {
        if bottomTextButton.isFirstResponder() {
            if view.frame.origin.y == 0 {
                // Subtract the height of the keyboard from the y-coordinate of the view
                view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if bottomTextButton.isFirstResponder() {
            if view.frame.origin.y < 0 {
                // Add the height of the keyboard to the y-coordinate of the view
                view.frame.origin.y += getKeyboardHeight(notification)
            }
        }
    }
}

/// Extension to `MemeEditorViewController` that implements some delegate functions
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
        else {
            var tempText: String!
            if textField.tag == TextType.Top.rawValue {
                tempText = topDefaultText
            }
            else {
                tempText = bottomDefaultText
            }
            
            // If the text is different from the default and an image was chosen, enable the
            // share button
            if textField.text != tempText && sourceImageView.image != nil {
                shareButton.enabled = true
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
            sourceImageView.image = image
            shareButton.enabled = true
            dismissViewControllerAnimated(true, completion: nil)
        }
    }
    
    func imagePickerControllerDidCancel(picker: UIImagePickerController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
}
