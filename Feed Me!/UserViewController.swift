//
//  UserViewController.swift
//  Feed Me!
//
//  Created by Administrator on 7/12/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import UIKit
import Parse


class UserViewController: UIViewController, UITextFieldDelegate {
    
    var imagePickerController: UIImagePickerController?
    var photoTakingHelper: PhotoTakingHelper?
    var image: UIImage?
    let user = PFUser.currentUser()

    
    @NSManaged var imageFile: PFFile?

    
    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var imagePicker: UIImageView!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.nameLabel.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        self.imagePicker.layer.borderWidth = 3
        self.imagePicker.layer.borderColor = UIColor(red:100/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        
        self.imagePicker.layer.cornerRadius = self.imagePicker.frame.size.width / 2;
        self.imagePicker.clipsToBounds = true
        
        self.fetchImage()
        
        self.saveText()
    }
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func photoLibrary(sender: AnyObject) {
        takePhoto()
    }
    
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            
            self.imagePicker.image = image
            self.image = image
            self.uploadImage()
        }
    }
    
    func saveText() {
        let nameStore = PFObject(className: "User")
        nameStore["Name"] = nameLabel
        user!.saveInBackgroundWithBlock(nil)
    }
    
    func retrieveText() {
        if let currentName = user?["Name"] as? String {
            self.nameLabel.text = currentName
        }
    }
    
    func uploadImage() {
        if let image = image {
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
            
            
            user!.setObject(imageFile, forKey: "imageFile")
            user!.saveInBackgroundWithBlock(nil)
        }
    }
    
    func fetchImage() {
        if let userPicture = user?["imageFile"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.imagePicker.image = UIImage(data: imageData!)
                }
            }
        }
        else {
            self.imagePicker.image = UIImage(named: "face")
        }

    }
            
}
