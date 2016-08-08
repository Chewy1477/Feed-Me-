//
//  ProfileViewController.swift
//  Feed Me!
//
//  Created by Administrator on 8/4/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import Foundation
import UIKit
import Parse

class ProfileViewController: UIViewController, UITextFieldDelegate {
    
    let user = PFUser.currentUser()

    
    @IBOutlet weak var profileName: UITextField!
    @IBOutlet weak var profileImage: UIImageView!
    @IBOutlet weak var profileAge: UITextField!
    @IBOutlet weak var profileFood: UITextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180.0/255.0, blue:220.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        self.profileName.delegate = self
        self.profileAge.delegate = self
        self.profileFood.delegate = self
        
        IconHelper.createIcon(profileName, image: "Dog Tag-50")
        IconHelper.createIcon(profileAge, image: "Age-50")
        IconHelper.createIcon(profileFood, image: "About-50")
        
        profileImage.image = UIImage(named: "pic")
        
    
    }
    
    func saveText() {
        let nameSave = self.profileName.text
        let ageSave = self.profileAge.text
        let foodSave = self.profileFood.text
        
        if self.profileName.text!.characters.count > 9 {
            self.alert("Too Long!", message: "Please enter a nickname less than 10 characters.")
        }
        else if self.profileFood.text!.characters.count > 9 {
            self.alert("Too Long!", message: "Please enter something that is less than 10 characters.")
        }
        else if self.profileAge.text!.characters.count > 3 {
            self.alert("Invalid!", message: "Please enter a valid age.")
        }
        
        user!.setObject(nameSave!, forKey: "Nickname")
        user!.setObject(ageSave!, forKey: "Age")
        user!.setObject(foodSave!, forKey: "Food")
        user!.saveInBackgroundWithBlock(nil)
        
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func didTapView(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func saveButton(sender: UIButton) {
        self.saveText()
    }
    
}