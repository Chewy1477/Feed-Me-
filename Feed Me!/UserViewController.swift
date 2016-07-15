//
//  UserViewController.swift
//  Feed Me!
//
//  Created by Administrator on 7/12/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import UIKit
import Parse


class UserViewController: UIViewController {
    
    var window: UIWindow?
    
    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view, typically from a nib.
        
    }
    
    
    @IBAction func signOutButton(sender: UIBarButtonItem) {
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
        
    }
    
}
