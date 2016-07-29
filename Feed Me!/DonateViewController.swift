//
//  DonateViewControllerDelegate.swift
//  Feed Me!
//
//  Created by Administrator on 7/27/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import Braintree

class DonateViewController: UIViewController, BTDropInViewControllerDelegate {
    
    var braintreeClient: BTAPIClient?
    var clientToken: String!
    
    override func viewDidLoad() {
        let clientTokenURL = NSURL(string: "https://feed-me-application.herokuapp.com/")!
        let clientTokenRequest = NSMutableURLRequest(URL: clientTokenURL)
        clientTokenRequest.setValue("text/plain", forHTTPHeaderField: "Accept")
        
        NSURLSession.sharedSession().dataTaskWithRequest(clientTokenRequest) { [unowned self] (data, response, error) -> Void in
            // TODO: Handle errors
            self.clientToken = NSString(data: data!, encoding: NSUTF8StringEncoding) as! String
            print(self.clientToken)
            
            // As an example, you may wish to present our Drop-in UI at this point.
            // Continue to the next section to learn more...
            }.resume()
    }


    func dropInViewController(viewController: BTDropInViewController,
                              didSucceedWithTokenization paymentMethodNonce: BTPaymentMethodNonce)
    {
        // Send payment method nonce to your server for processing
        postNonceToServer(paymentMethodNonce.nonce)
        dismissViewControllerAnimated(true, completion: nil)
    }
    
    func dropInViewControllerDidCancel(viewController: BTDropInViewController) {
        dismissViewControllerAnimated(true, completion: nil)
    }

    func postNonceToServer(paymentMethodNonce: String) {
        let paymentURL = NSURL(string: "https://feed-me-application.herokuapp.com/")!
        let request = NSMutableURLRequest(URL: paymentURL)
        request.HTTPBody = "payment_method_nonce=\(paymentMethodNonce)".dataUsingEncoding(NSUTF8StringEncoding)
        request.HTTPMethod = "POST"
        
        NSURLSession.sharedSession().dataTaskWithRequest(request) { (data, response, error) -> Void in
            // TODO: Handle success or failure
            }.resume()
    }
    
    func tappedMyPayButton() {
        // If you haven't already, create and retain a `BTAPIClient` instance with a
        // tokenization key OR a client token from your server.
        // Typically, you only need to do this once per session.
        print(clientToken)
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
    
    @IBAction func donateButton(sender: AnyObject) {
        self.tappedMyPayButton()
    }
    
}
