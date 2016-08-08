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
    var amount: String = "1"
    var checkSubmit: Bool = false
    var canProceed: Bool = false


    @IBOutlet weak var amountDonation: UISegmentedControl!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
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
    
    override func viewDidAppear(animated: Bool) {
        if checkSubmit == true {
            self.alert("Complete!", message: "Information Submitted.")
            checkSubmit = false
        }
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

    func userDidCancelPayment() {
        dismissViewControllerAnimated(true, completion: nil)
    }

    @IBAction func fillButton(sender: UIButton) {
        let billing = self.storyboard!.instantiateViewControllerWithIdentifier("BillingViewController")
        self.presentViewController(billing, animated: true, completion: nil)
    }
    
    
    @IBAction func proceedButton(sender: UIBarButtonItem) {
        
        if canProceed == true {
            self.tappedMyPayButton()
        }
        else {
            self.alert("Oops!", message: "Please click the pencil.")

        }
    }
    
    
    @IBAction func changeAmount(sender: UISegmentedControl) {
        switch amountDonation.selectedSegmentIndex {
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


extension UIViewController {
    
    func alert(title: String, message: String) {
        let alert = UIAlertController(title: title, message: message, preferredStyle: UIAlertControllerStyle.Alert)
        alert.addAction(UIAlertAction(title: "OK", style: UIAlertActionStyle.Default, handler: nil))
        self.presentViewController(alert, animated: true, completion: nil)
    }
    
}

