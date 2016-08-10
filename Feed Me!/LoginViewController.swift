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
    let logoLogin = UILabel()
    var count: Int = 0
    var moveUp: Bool = false

    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.signUpController = SignUpViewController()
        
        logoLogin.text = "Feed Me!"
        logoLogin.textColor = UIColor.whiteColor()
        logoLogin.font = UIFont(name: "Arial", size: 60)
        logoLogin.shadowColor = UIColor.lightGrayColor()
        logoLogin.shadowOffset = CGSizeMake(3,3)
        
        logInView?.logo = logoLogin
        logInView?.contentMode = .ScaleAspectFit
        
        logInView?.logInButton?.setBackgroundImage(nil, forState: .Normal)
        logInView?.logInButton?.backgroundColor = UIColor(red: 0.0/255, green: 180/255, blue: 220/255, alpha: 1)
        logInView?.passwordForgottenButton?.setTitleColor(UIColor.whiteColor(), forState: .Normal)
        
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
    
    override func viewWillAppear(animated: Bool) {
        super.viewWillAppear(animated)

        logInView?.logInButton!.alpha = 0.0
    }
    
    override func viewDidDisappear(animated: Bool) {
        super.viewDidDisappear(animated)
        
        self.logInView?.logo!.center.y -= self.view.bounds.width
        self.moveUp = true

    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)

        if moveUp == false {
            self.logInView?.logo!.center.y -= self.view.bounds.width
        }
        UIView.animateWithDuration(2.0, animations: {
            self.logoLogin.center.y += self.view.bounds.width
        })
        
        
        UIView.animateWithDuration(1.0, delay: 2.0, options: [], animations: {
            self.logInView?.logInButton!.alpha = 1.0
            }, completion: nil)
    }

    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
     
        
        let motionView: PanoramaView = PanoramaView(frame: self.view.bounds)
        motionView.setImage(UIImage(named:"try")!)
        logInView!.insertSubview(motionView, atIndex: 0)
        
        let signMotionView: PanoramaView = PanoramaView(frame: self.view.bounds)
        signMotionView.setImage(UIImage(named:"blur")!)
        signUpController!.signUpView?.insertSubview(signMotionView, atIndex: 0)
    }

}
    

