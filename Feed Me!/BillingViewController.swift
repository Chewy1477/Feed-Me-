//
//  BillingViewController.swift
//  Feed Me!
//
//  Created by Administrator on 8/6/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import Foundation
import UIKit
import IQDropDownTextField
import Parse

class BillingViewController: UIViewController, UITextFieldDelegate, IQDropDownTextFieldDelegate {
    
    var filledFields: Bool = false
    let user = PFUser.currentUser()

    
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var billingAddress: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: IQDropDownTextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var recipientField: IQDropDownTextField!
    
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.phoneNumber.delegate = self
        self.billingAddress.delegate = self
        self.zipCode.delegate = self
        
        self.stateField.delegate = self
        self.recipientField.delegate = self
        
        stateField.isOptionalDropDown = false
        recipientField.isOptionalDropDown = false
        
        stateField.itemList = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts","Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
        
        recipientField.itemList = ["Pizza Hut", "Panera Bread", "Dominoes"]
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(BillingViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        let iqToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        iqToolbar.items = [UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.doneEditing))]
        iqToolbar.sizeToFit()
        
        recipientField.inputAccessoryView = iqToolbar
        stateField.inputAccessoryView = iqToolbar
        
        IconHelper.createIcon(firstName, image: "Phone Filled-50")
//        IconHelper.createIcon(lastName, image: "Age-50")
//        IconHelper.createIcon(phoneNumber, image: "About-50")
//        IconHelper.createIcon(billingAddress, image: "Dog Tag-50")
//        IconHelper.createIcon(zipCode, image: "Age-50")
        
        self.retrieveText()
    
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    func doneEditing(CardTypeTextField: IQDropDownTextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }
    
    func saveText() {
        let saveFirst = self.firstName.text
        let saveLast = self.lastName.text
        let savePhone = self.phoneNumber.text
        let saveBilling = self.billingAddress.text
        let saveCity = self.cityField.text
        let saveState = self.stateField.selectedItem
        let saveZip = self.zipCode.text
        let saveRecipient = self.recipientField.selectedItem
        
        
//        if self.profileName.text!.characters.count > 9 {
//            self.alert("Too Long!", message: "Please enter a nickname less than 10 characters.")
//        }
//        else if self.profileFood.text!.characters.count > 9 {
//            self.alert("Too Long!", message: "Please enter something that is less than 10 characters.")
//        }
//        else if self.profileAge.text!.characters.count > 3 {
//            self.alert("Invalid!", message: "Please enter a valid age.")
//        }
        
        user!.setObject(saveFirst!, forKey: "First")
        user!.setObject(saveLast!, forKey: "Last")
        user!.setObject(savePhone!, forKey: "Phone")
        user!.setObject(saveBilling!, forKey: "Billing")
        user!.setObject(saveCity!, forKey: "City")
        user!.setObject(saveState!, forKey: "State")
        user!.setObject(saveZip!, forKey: "Zip")
        user!.setObject(saveRecipient!, forKey: "Recipient")


        user!.saveInBackgroundWithBlock(nil)
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
    func retrieveText() {
        guard let nameGet = (user?["Name"] as! String?), lastGet = (user?["Last"] as! String?), phoneGet = (user?["Phone"] as! String?), billingGet = (user?["Billing"] as! String?), cityGet = (user?["City"] as! String?), stateGet = (user?["State"] as! String?), zipGet = (user?["Zip"] as! String?), recipientGet = (user?["Recipient"] as! String?)  else {
            return
        }
        
        self.firstName.text = nameGet
        self.lastName.text = lastGet
        self.phoneNumber.text = phoneGet
        self.billingAddress.text = billingGet
        self.cityField.text = cityGet
        self.stateField.selectedItem = stateGet
        self.zipCode.text = zipGet
        self.recipientField.selectedItem = recipientGet
        
    }

    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButton(sender: UIButton) {
        if firstName.isValidEntry() && lastName.isValidEntry() && phoneNumber.isValidEntry() && billingAddress.isValidEntry() && zipCode.isValidEntry() {
            self.alert("Complete", message: "Information Submitted!")
            filledFields = true
            self.dismissViewControllerAnimated(true, completion: nil)
        }
        else {
            self.alert("Oops!", message: "Please fill in every field.")
        }

    }
}

extension UITextField {
    
    func isValidEntry() -> Bool {
        if self.text != nil && self.text != "" {
            return true
        } else {
            return false
        }
    }
}
