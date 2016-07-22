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
    var check: Bool = true
    
    override func viewDidLoad() {
        super.viewDidLoad()

        // Do any additional setup after loading the view.
    }

    override func didReceiveMemoryWarning() {
        super.didReceiveMemoryWarning()
        // Dispose of any resources that can be recreated.
    }
    

    @IBAction func signOut(sender: UIBarButtonItem) {
    
        PFUser.logOut()
        self.dismissViewControllerAnimated(true, completion: nil)
        let loginViewController = LoginViewController()
        self.prenent
        
        }
    }


