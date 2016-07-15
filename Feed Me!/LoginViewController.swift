//
//  LoginViewController.swift
//  Feed Me!
//
//  Created by Administrator on 7/14/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import ParseUI

class LoginViewController: PFLogInViewController {
    var myView: UIView!
    var backgroundImage: UIImageView!
    var signUpImage: UIImageView!

    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        backgroundImage = UIImageView(image: UIImage(named: "Helping Hand"))
        logInView?.insertSubview(backgroundImage, atIndex: 0)
        
        let logoLogin = UILabel()
        logoLogin.text = "Feed Me!"
        logoLogin.textColor = UIColor.whiteColor()
        logoLogin.font = UIFont(name: "Arial", size: 60)
        logoLogin.shadowColor = UIColor.lightGrayColor()
        
        logInView?.logo = logoLogin
        logInView!.logo!.sizeToFit()
        
        signUpImage = UIImageView(image: UIImage(named: "Helping Hand"))
        signUpController?.signUpView!.insertSubview(signUpImage, atIndex: 0)
        
        let logoSign = UILabel()
        logoSign.text = "Sign Up!"
        logoSign.textColor = UIColor.whiteColor()
        logoSign.font = UIFont(name: "Arial", size: 40)
        logoSign.shadowColor = UIColor.lightGrayColor()
        
        signUpController?.signUpView?.logo = logoSign
        signUpController?.signUpView!.logo!.sizeToFit()
        
    }
 
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        
        backgroundImage.frame = CGRectMake(0, 0,  logInView!.frame.width,  logInView!.frame.height)
        signUpImage.frame = CGRectMake(0,0, logInView!.frame.width, logInView!.frame.height)
    }
}
