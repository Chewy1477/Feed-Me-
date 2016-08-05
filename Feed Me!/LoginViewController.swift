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
        logoLogin.shadowOffset = CGSizeMake(3,3)
        
        logInView?.logo = logoLogin
        logInView?.contentMode = .ScaleAspectFit
        
        let logoSign = UILabel()
        logoSign.text = "Sign Up!"
        logoSign.textColor = UIColor.whiteColor()
        logoSign.font = UIFont(name: "Arial", size: 40)
        logoSign.shadowColor = UIColor.lightGrayColor()
        logoSign.shadowOffset = CGSizeMake(3,3)
        
        signUpController?.signUpView?.logo = logoSign
        signUpController?.signUpView?.contentMode = .ScaleAspectFit
        
        logInView?.logInButton?.setBackgroundImage(nil, forState: .Normal)
        logInView?.logInButton?.backgroundColor = UIColor(red: 52/255, green: 191/255, blue: 73/255, alpha: 1)
        logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
        signUpController?.signUpView?.signUpButton?.setBackgroundImage(nil, forState: .Normal)
        signUpController?.signUpView?.signUpButton?.backgroundColor = UIColor(red: 200/255, green: 100/255, blue: 200/255, alpha: 1)
        customizeButton(logInView?.facebookButton!)
        customizeButton(logInView?.signUpButton!)
    }
    
    func customizeButton(button: UIButton!) {
        button.setBackgroundImage(nil, forState: .Normal)
        button.backgroundColor = UIColor.clearColor()
        button.layer.cornerRadius = 5
        button.layer.borderWidth = 1
        button.layer.borderColor = UIColor.whiteColor().CGColor
    }

    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        let motionView: PanoramaView = PanoramaView(frame: self.view.bounds)
        motionView.setImage(UIImage(named:"feed")!)
        logInView!.insertSubview(motionView, atIndex: 0)
        
        let signUpView: PanoramaView = PanoramaView(frame: self.view.bounds)
        signUpView.setImage(UIImage(named:"test")!)
        signUpController?.signUpView?.insertSubview(signUpView, atIndex: 0)
    }
    
}
