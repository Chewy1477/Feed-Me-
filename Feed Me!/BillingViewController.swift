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
    
    let user = PFUser.currentUser()
    var checkSubmit: Bool = false
    
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

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
//        print((user?["First"] as! String?))
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
        
        user!.setObject(saveFirst!, forKey: "First")
        user!.setObject(saveLast!, forKey: "Last")
        user!.setObject(savePhone!, forKey: "Phone")
        user!.setObject(saveBilling!, forKey: "Billing")
        user!.setObject(saveCity!, forKey: "City")
        user!.setObject(saveState!, forKey: "State")
        user!.setObject(saveZip!, forKey: "Zip")
        user!.setObject(saveRecipient!, forKey: "Recipient")

        user!.saveInBackgroundWithBlock(nil)
        

        
        
    }
    
    func retrieveText() {
        guard let firstGet = (user?["First"] as! String?), lastGet = (user?["Last"] as! String?), phoneGet = (user?["Phone"] as! String?), billingGet = (user?["Billing"] as! String?), cityGet = (user?["City"] as! String?), stateGet = (user?["State"] as! String?), zipGet = (user?["Zip"] as! String?), recipientGet = (user?["Recipient"] as! String?)  else {
            return
        }

        self.firstName.text = firstGet
        self.lastName.text = lastGet
        self.phoneNumber.text = phoneGet
        self.billingAddress.text = billingGet
        self.cityField.text = cityGet
        self.stateField.selectedItem = stateGet
        self.zipCode.text = zipGet
        self.recipientField.selectedItem = recipientGet
        
    }
    
    override func prepareForSegue(segue: UIStoryboardSegue, sender: AnyObject?) {
        if segue.identifier == "segueDonateLib" {
            if let DonateViewController = segue.destinationViewController as? DonateViewController {
                DonateViewController.checkSubmit = true
                DonateViewController.canProceed = true
            }
        }
    }

    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButton(sender: UIButton) {
        if firstName.isValidEntry() && lastName.isValidEntry() && phoneNumber.isValidEntry() && billingAddress.isValidEntry() && zipCode.isValidEntry() && cityField.isValidEntry() {
            performSegueWithIdentifier("segueDonateLib", sender: sender)
            self.saveText()

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
