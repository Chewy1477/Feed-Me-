//
//  DonateViewController.swift
//  Feed Me!
//
//  Created by Administrator on 7/13/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import IQDropDownTextField
import UIKit

class DonateViewController: UIViewController, UITextFieldDelegate {
   
    @IBOutlet weak var CustomTextField: UITextField!
    @IBOutlet weak var NameTextField: UITextField!
    @IBOutlet weak var AddressTextField: UITextField!
    @IBOutlet weak var CardTypeTextField: IQDropDownTextField!
    @IBOutlet weak var CardNumberTextField: UITextField!
    @IBOutlet weak var CVCTextField: UITextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
        self.CustomTextField.delegate = self
        self.NameTextField.delegate = self
        self.AddressTextField.delegate = self
        self.CardTypeTextField.delegate = CardTypeTextField.delegate
        self.CardNumberTextField.delegate = self
        self.CVCTextField.delegate = self
        
        CardTypeTextField.isOptionalDropDown = true
        CardTypeTextField.itemList = ["programmer", "teacher", "engineer"]
        
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numberToolbar.items = [UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.doneEditing))]
        numberToolbar.sizeToFit()
        CardTypeTextField.inputAccessoryView = numberToolbar
        
        
    }
    
    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func doneEditing(CardTypeTextField: IQDropDownTextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    @IBAction func SubmitDonation(sender: UIButton) {
    }

}
