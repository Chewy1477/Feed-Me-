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
import Braintree

class DonateViewController: UIViewController, UITextFieldDelegate, IQDropDownTextFieldDelegate, BTDropInViewControllerDelegate {
    
    let user = PFUser.currentUser()
    var braintreeClient: BTAPIClient?
    var clientToken: String!
    var amount: String = "1"
    var checkProceed: Bool = false

    
    @IBOutlet weak var lastName: UITextField!
    @IBOutlet weak var firstName: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var cityField: UITextField!
    @IBOutlet weak var stateField: IQDropDownTextField!
    @IBOutlet weak var recipientField: IQDropDownTextField!
    
    @IBOutlet weak var amountPick: UISegmentedControl!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.firstName.delegate = self
        self.lastName.delegate = self
        self.phoneNumber.delegate = self
        self.stateField.delegate = self
        self.recipientField.delegate = self
        
        stateField.isOptionalDropDown = false
        recipientField.isOptionalDropDown = false
        
        stateField.itemList = ["Alabama", "Alaska", "Arizona", "Arkansas", "California", "Colorado", "Connecticut", "Delaware", "Florida", "Georgia", "Hawaii", "Idaho", "Illinois", "Indiana", "Iowa", "Kansas", "Kentucky", "Louisiana", "Maine", "Maryland", "Massachusetts","Michigan", "Minnesota", "Mississippi", "Missouri", "Montana", "Nebraska", "Nevada", "New Hampshire", "New Jersey", "New Mexico", "New York", "North Carolina", "North Dakota", "Ohio", "Oklahoma", "Oregon", "Pennsylvania", "Rhode Island", "South Carolina", "South Dakota", "Tennessee", "Texas", "Utah", "Vermont", "Virginia", "Washington", "West Virginia", "Wisconsin", "Wyoming"]
        
        recipientField.itemList = ["Pizza Hut", "Panera Bread", "Dominoes"]
        
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(DonateViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        let iqToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        iqToolbar.items = [UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.doneEditing))]
        iqToolbar.sizeToFit()
        
        recipientField.inputAccessoryView = iqToolbar
        stateField.inputAccessoryView = iqToolbar
        
        IconHelper.createIcon(firstName, image: "Name")
        IconHelper.createIcon(lastName, image: "Name")
        IconHelper.createIcon(phoneNumber, image: "Phone")
        IconHelper.createIcon(cityField, image: "3")
        IconHelper.createIcon(stateField, image: "US")
        IconHelper.createIcon(recipientField, image: "Feedback")
        
        
        let clientTokenURL = NSURL(string: "https://feed-me-application.herokuapp.com/client_token")!
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        NSURLSession.sharedSession().dataTaskWithRequest(clientTokenRequest) { [unowned self] (data, response, error) -> Void in
            // TODO: Handle errors
            self.clientToken = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String

            }.resume()


    }
    
    override func viewDidAppear(animated: Bool) {
        self.retrieveText()
    }
    
    
    func dropInViewController(viewController: BTDropInViewController,
                              didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce)
    {
        // Send payment method nonce to your server for processing
        postNonceToServer(paymentMethodNonce.nonce, amount: amount)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func postNonceToServer(paymentMethodNonce: String, amount: String) {
        let paymentURL = NSURL(string: "https://feed-me-application.herokuapp.com/payment")!
        let request = NSMutableURLRequest(URL: paymentURL)
        request.HTTPBody = "payment_method_nonce=\(paymentMethodNonce)&amountDonation=\(amount)".dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
            }.resume()
    }
    
    func tappedMyPayButton() {

        braintreeClient = BTAPIClient(authorization: clientToken)
        
        let dropInViewController = BTDropInViewController(APIClient: braintreeClient!)
        dropInViewController.delegate = self

        dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Cancel,
            target: self, action: #selector(DonateViewController.userDidCancelPayment))
        let navigationController = UINavigationController(rootViewController: dropInViewController)
        
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func userDidCancelPayment() {
        dismissViewControllerAnimated(true, completion: nil)
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
        let saveCity = self.cityField.text
        let saveState = self.stateField.selectedItem
        let saveRecipient = self.recipientField.selectedItem
        
        user!.setObject(saveFirst!, forKey: "First")
        user!.setObject(saveLast!, forKey: "Last")
        user!.setObject(savePhone!, forKey: "Phone")
        user!.setObject(saveCity!, forKey: "City")
        user!.setObject(saveState!, forKey: "State")
        user!.setObject(saveRecipient!, forKey: "Recipient")
        

        user!.saveInBackgroundWithBlock(nil)
    }
    
    func retrieveText() {
        guard let firstGet = (user?["First"] as! String?), lastGet = (user?["Last"] as! String?), phoneGet = (user?["Phone"] as! String?), cityGet = (user?["City"] as! String?), stateGet = (user?["State"] as! String?), recipientGet = (user?["Recipient"] as! String?)  else {
            return
        }

        self.firstName.text = firstGet
        self.lastName.text = lastGet
        self.phoneNumber.text = phoneGet
        self.cityField.text = cityGet
        self.stateField.selectedItem = stateGet
        self.recipientField.selectedItem = recipientGet
        
    }

    
    @IBAction func submitButton(sender: UIButton) {
        if firstName.isValidEntry() && lastName.isValidEntry() && phoneNumber.isValidEntry() && cityField.isValidEntry() {
            self.saveText()
            self.alert("Information Saved!", message: "Click the arrow the proceed.")
            checkProceed = true

        }
        else {
            self.alert("Oops!", message: "Please fill in every field.")
        }
    }
    @IBAction func proceedButton(sender: AnyObject) {
        if checkProceed == true {
            self.tappedMyPayButton()
        }
        else {
            self.alert("Oops!", message: "Please fill out the information.")
        }
    }
    
    
    @IBAction func changeAmount(sender: AnyObject) {
        switch amountPick.selectedSegmentIndex {
        case 0:
            amount = "1"
        case 1:
            amount = "5"
        case 2:
            amount = "10"
        default:
            break;
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

extension UIViewController {
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

