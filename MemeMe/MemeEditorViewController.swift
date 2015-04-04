//
//  MemeEditorViewController.swift
//  MemeMe
//
//  Created by Jeffrey Sulton on 3/22/15.
//  Copyright (c) 2015 notlus. All rights reserved.
//

import UIKit

class MemeEditorViewController: UIViewController {
    private let appDelegate = UIApplication.sharedApplication().delegate as AppDelegate

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
    
    override func viewDidLoad() {
        super.viewDidLoad()

        self.shareButton.enabled = false
        self.cameraButton.enabled = UIImagePickerController.isSourceTypeAvailable(UIImagePickerControllerSourceType.Camera)
        self.initializeTextFields()
    }
    
    override func viewWillAppear(animated: Bool) {
        println("viewWillAppear")
        super.viewWillAppear(animated)
        self.subscribeToKeyboardNotifications()
    }
    
    override func viewWillDisappear(animated: Bool) {
        println("viewWillDisappear")
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
                if let index = self.memeIndex {
                    // Replace an existing meme at index
                    self.appDelegate.memes[index] = meme
                }
                else {
                    // Create a new meme
                    self.appDelegate.memes.append(meme)
                }
                self.dismissViewControllerAnimated(true, completion: nil)
            }
        }
        
        self.presentViewController(activityView, animated: true, completion: nil)
    }
    
    @IBAction func cancel(sender: AnyObject) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    // MARK: - Helpers
    
    func initializeTextFields() {
        self.topTextButton.delegate = self
        self.topTextButton.defaultTextAttributes = self.memeTextAttributes
        self.topTextButton.textAlignment = NSTextAlignment.Center
        self.topTextButton.tag = TextType.Top.rawValue

        self.bottomTextButton.delegate = self
        self.bottomTextButton.defaultTextAttributes = self.memeTextAttributes
        self.bottomTextButton.textAlignment = NSTextAlignment.Center
        self.bottomTextButton.tag = TextType.Bottom.rawValue
        
        if let index = self.memeIndex {
            self.topTextButton.text = self.appDelegate.memes[index].topText
            self.bottomTextButton.text = self.appDelegate.memes[index].bottomText
            self.sourceImageView.image = self.appDelegate.memes[index].sourceImage
        }
        else {
            self.topTextButton.text = self.topDefaultText
            self.bottomTextButton.text = self.bottomDefaultText
        }
    }
    
    func generateMemedImage() -> UIImage {
        // Hide the top and bottom toolbars before capturing the image
        self.topToolBar.hidden = true
        self.memeEditorToolBar.hidden = true
        
        UIGraphicsBeginImageContext(self.view.frame.size)
        self.view.drawViewHierarchyInRect(self.view.frame, afterScreenUpdates: true)
        let context = UIGraphicsGetCurrentContext()
        let memedImage = UIGraphicsGetImageFromCurrentImageContext()
        UIGraphicsEndImageContext()
        
        // Show the navigation bar and bottom toolbar again
        self.navigationController?.navigationBar.hidden = false
        self.topToolBar.hidden = false
        self.memeEditorToolBar.hidden = false
        
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
            println("view height = \(self.view.frame.origin.y)")
            println("keyboard height = \(getKeyboardHeight(notification))")
            
            if self.view.frame.origin.y == 0 {
                // Subtract the height of the keyboard from the y-coordinate of the view
                self.view.frame.origin.y -= getKeyboardHeight(notification)
            }
        }
    }
    
    func keyboardWillHide(notification: NSNotification) {
        if self.bottomTextButton.isFirstResponder() {
            println("willHide....")
            println("view height = \(self.view.frame.origin.y)")
            println("keyboard height = \(getKeyboardHeight(notification))")
            
            if self.view.frame.origin.y < 0 {
                // Add the height of the keyboard to the y-coordinate of the view
                self.view.frame.origin.y += getKeyboardHeight(notification)
            }
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
        else {
            var tempText: String!
            if textField.tag == TextType.Top.rawValue {
                tempText = self.topDefaultText
            }
            else {
                tempText = self.bottomDefaultText
            }
            
            // If the text is different from the default and an image was chosen, enable the
            // share button
            if textField.text != tempText && self.sourceImageView.image != nil {
                self.shareButton.enabled = true
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
