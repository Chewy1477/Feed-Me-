//
//  HomeViewController.swift
//  Feed Me!
//
//  Created by Administrator on 7/18/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import UIKit
import Parse

class HomeViewController: UIViewController {
    
    var window: UIWindow?
    var parseLoginHelper: ParseLoginHelper!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        parseLoginHelper = ParseLoginHelper {[unowned self] user, error in
            // Initialize the ParseLoginHelper with a callback
            if let error = error {
                // 1
                ErrorHandling.defaultErrorHandler(error)
            } else  if let _ = user {
                // if login was successful, display the TabBarController
                // 2
                let storyboard = UIStoryboard(name: "Main", bundle: nil)
                let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
                // 3
                self.window?.rootViewController!.presentViewController(tabBarController, animated:true, completion:nil)
                
            }
        }
        
        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signOut(sender: UIBarButtonItem) {
        
        let returnViewController = LoginViewController()
        
        returnViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .Facebook]
        returnViewController.delegate = parseLoginHelper
        returnViewController.signUpController?.delegate = parseLoginHelper
        
        PFUser.logOut()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = returnViewController
        self.window?.makeKeyAndVisible()
        
        
    }
}


