//
//  DonateViewControllerDelegate.swift
//  Feed Me!
//
//  Created by Administrator on 7/27/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import Braintree
import IQDropDownTextField
import UIKit

class DonateViewController: UIViewController, UITextFieldDelegate, BTDropInViewControllerDelegate {
    
    var braintreeClient: BTAPIClient?
    var clientToken: String!
    var amount: String!
    var getPostal: String!
    var filledFields: Bool = false
    
    @IBOutlet weak var otherAmount: UITextField!
    @IBOutlet weak var amountDonation: UISegmentedControl!
    @IBOutlet weak var firstLabel: UITextField!
    @IBOutlet weak var lastLabel: UITextField!
    @IBOutlet weak var phoneNumber: UITextField!
    @IBOutlet weak var billingAddress: UITextField!
    @IBOutlet weak var zipCode: UITextField!
    @IBOutlet weak var recipientField: IQDropDownTextField!
    
    override func viewDidLoad() {
        super.viewDidLoad()
            
        let tapRecognizer = UITapGestureRecognizer()
        tapRecognizer.addTarget(self, action: #selector(DonateViewController.didTapView))
        self.view.addGestureRecognizer(tapRecognizer)
        
        self.recipientField.delegate = recipientField.delegate
        recipientField.isOptionalDropDown = false
        recipientField.itemList = ["programmer", "teacher", "engineer"]
        
        let numberToolbar = UIToolbar(frame: CGRectMake(0, 0, self.view.frame.size.width, 50))
        numberToolbar.items = [UIBarButtonItem(title: "Done", style: UIBarButtonItemStyle.Plain, target: self, action: #selector(self.doneEditing))]
        numberToolbar.sizeToFit()
        recipientField.inputAccessoryView = numberToolbar
        
        self.firstLabel.delegate = self
        self.lastLabel.delegate = self
        self.billingAddress.delegate = self
        self.zipCode.delegate = self
        self.phoneNumber.delegate = self
        
        let clientTokenURL = NSURL(string: "https://feed-me-application.herokuapp.com/client_token")!
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        NSURLSession.sharedSession().dataTaskWithRequest(clientTokenRequest) { [unowned self] (data, response, error) -> Void in
            // TODO: Handle errors
            self.clientToken = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            
            // As an example, you may wish to present our Drop-in UI at this point.
            // Continue to the next section to learn more...
            }.resume()
    }

    func doneEditing(CardTypeTextField: IQDropDownTextField) -> Bool {
        self.view.endEditing(true)
        return false
    }

    func dropInViewController(viewController: BTDropInViewController,
                              didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce)
    {
        // Send payment method nonce to your server for processing
        postNonceToServer(paymentMethodNonce.nonce, amount: amount, getPostal: getPostal)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func postNonceToServer(paymentMethodNonce: String, amount: String, getPostal: String) {
        let paymentURL = NSURL(string: "https://feed-me-application.herokuapp.com/payment")!
        let request = NSMutableURLRequest(URL: paymentURL)
        request.HTTPBody = "payment_method_nonce=\(paymentMethodNonce)&amountDonation=\(amount)&postalNumber=\(getPostal)".dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
            }.resume()
    }
    
    func tappedMyPayButton() {
        // If you haven't already, create and retain a `BTAPIClient` instance with a
        // tokenization key OR a client token from your server.
        // Typically, you only need to do this once per session.
        braintreeClient = BTAPIClient(authorization: clientToken)
        
        // Create a BTDropInViewController
        let dropInViewController = BTDropInViewController(APIClient: braintreeClient!)
        dropInViewController.delegate = self
        // This is where you might want to customize your view controller (see below)
        
        // The way you present your BTDropInViewController instance is up to you.
        // In this example, we wrap it in a new, modally-presented navigation controller:
        dropInViewController.navigationItem.leftBarButtonItem = UIBarButtonItem(
            barButtonSystemItem: UIBarButtonSystemItem.Cancel,
            target: self, action: #selector(DonateViewController.userDidCancelPayment))
        let navigationController = UINavigationController(rootViewController: dropInViewController)
        
        
        presentViewController(navigationController, animated: true, completion: nil)
    }
    
    func didTapView(){
        self.view.endEditing(true)
    }
    
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true);
        return false;
    }

    func userDidCancelPayment() {
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    @IBAction func submitButton(sender: UIButton) {
    
        if firstLabel.isValidEntry() && lastLabel.isValidEntry() && phoneNumber.isValidEntry() && billingAddress.isValidEntry() && zipCode.isValidEntry() {
            let alert = UIAlertController(title: "Complete!", message: "Information submitted.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
            
            filledFields = true
        }
        else {
            let alert = UIAlertController(title: "Oops!", message: "Please fill in every field.", preferredStyle: UIAlertControllerStyle.Alert)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            self.presentViewController(alert, animated: true, completion: nil)
        }
    }
    
    
    
    @IBAction func proceedButton(sender: UIBarButtonItem) {
        
        if filledFields == true {
            self.tappedMyPayButton()
        }
        else {
            let alert = UIAlertController(title: "Oops!", message: "Please click submit.", preferredStyle: UIAlertControllerStyle.Alert)
            
            // add an action (button)
            alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
            
            // show the alert
            self.presentViewController(alert, animated: true, completion: nil)

        }
    }
    
    
    @IBAction func changeAmount(sender: UISegmentedControl) {
        switch sender.selectedSegmentIndex {
        case 0:
            amount = "1"
        case 1:
            amount = "5"
        case 2:
            amount = "10"
        case 3:
            amount = otherAmount.text
        default:
            break;
        }  //Switch
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

