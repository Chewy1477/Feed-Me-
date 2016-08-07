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

class BillingViewController: UIViewController, UITextFieldDelegate {
    
    var filledFields: Bool = false
    
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var billingAddress: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var recipientField: IQDropDownTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.phoneNumber.delegate = self
        self.billingAddress.delegate = self
        self.zipCode.delegate = self
        
        self.recipientField.delegate = recipientField.delegate
        recipientField.isOptionalDropDown = false
        recipientField.itemList = ["programmer", "teacher", "engineer"]
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(BillingViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numberToolbar.items = [UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.doneEditing))]
        numberToolbar.sizeToFit()
        recipientField.inputAccessoryView = numberToolbar
    
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
    
    @IBAction func cancelButton(sender: UIBarButtonItem) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButton(sender: UIButton) {
        if firstName.isValidEntry() && lastName.isValidEntry() && phoneNumber.isValidEntry() && billingAddress.isValidEntry() && zipCode.isValidEntry() {
            self.alert("Complete", message: "Information Submitted!")
            
            filledFields = true
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
