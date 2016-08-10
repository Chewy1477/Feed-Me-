//
//  SignUpViewController.swift
//  Feed Me!
//
//  Created by Administrator on 8/9/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import UIKit
import Parse
import ParseUI

class SignUpViewController: PFSignUpViewController {

    let logoSign = UILabel()
    var moveLogo: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        logoSign.text = "Sign Up!"
        logoSign.textColor = UIColor.whiteColor()
        logoSign.font = UIFont(name: "Arial", size: 40)
        logoSign.shadowColor = UIColor.lightGrayColor()
        logoSign.shadowOffset = CGSizeMake(3,3)

        signUpView?.logo = logoSign
        signUpView?.contentMode = .ScaleAspectFit
        // Do any additional setup after loading the view.
        
        signUpView?.signUpButton?.setBackgroundImage(nil, forState: .Normal)
        signUpView?.signUpButton?.backgroundColor = UIColor(red: 0/255, green: 180/255, blue: 220/255, alpha: 1)

    }
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)
        
        signUpView?.signUpButton!.alpha = 0.0
    
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
        
        UIView.animateWithDuration(1.0, delay: 1.0, options: [], animations: {
            self.signUpView?.signUpButton!.alpha = 1.0
            }, completion: nil)
        
    }

}
