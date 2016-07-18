//
//  UserViewController.swift
//  Feed Me!
//
//  Created by Administrator on 7/12/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import UIKit
import Parse


class UserViewController: UIViewController {
    
    var imagePickerController: UIImagePickerController?
    var photoTakingHelper: PhotoTakingHelper?
    

    @IBOutlet weak var imagePicker: UIImageView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        self.imagePicker.layer.borderWidth = 5
        self.imagePicker.layer.borderColor = UIColor(red:222/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        
    }
    
    @IBAction func photoLibrary(sender: AnyObject) {
        takePhoto()
    }
    
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            let user = User()
            user.image = image
            user.uploadImage()
        }
    }
    
    
    @IBAction func signOutButton(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)

    }
    
}
