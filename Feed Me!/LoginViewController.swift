//
//  LoginViewController.swift
//  Feed Me!
//
//  Created by Administrator on 7/14/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import UIKit
import Parse
import FBSDKCoreKit
import ParseUI
import ParseFacebookUtilsV4

class LoginViewController: PFLogInViewController {
    
    var parseLoginHelper: ParseLoginHelper!

    override func viewDidLoad() {
        super.viewDidLoad()
        
        let logoLogin = UILabel()
        logoLogin.text = "Feed Me!"
        logoLogin.textColor = UIColor.whiteColor()
        logoLogin.font = UIFont(name: "Arial", size: 60)
        logoLogin.shadowColor = UIColor.lightGrayColor()
        
        logInView?.logo = logoLogin
        logInView?.contentMode = .ScaleAspectFit
        
        let logoSign = UILabel()
        logoSign.text = "Sign Up!"
        logoSign.textColor = UIColor.whiteColor()
        logoSign.font = UIFont(name: "Arial", size: 40)
        logoSign.shadowColor = UIColor.lightGrayColor()
        
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let motionView: PanoramaView = PanoramaView(frame: self.view.bounds)
        motionView.setImage(UIImage(named:"360")!)
        logInView!.insertSubview(motionView, atIndex: 0)
//        signUpController?.signUpView!.insertSubview(motionView, atIndex: 0)
    }
    
}
