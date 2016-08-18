//
//  ParseLoginHelper.swift
//  Makestagram
//
//  Created by Benjamin Encz on 4/15/15.
//  Copyright (c) 2015 Make School. All rights reserved.
//

import Foundation
import FBSDKCoreKit
import Parse
import ParseUI

typealias ParseLoginHelperCallback = (PFUser?, NSError?) -> Void

class ParseLoginHelper : NSObject {
    static let errorDomain = "com.makeschool.parseloginhelpererrordomain"
    static let usernameNotFoundErrorCode = 1
    static let usernameNotFoundLocalizedDescription = "Could not retrieve Facebook username"
    
    let callback: ParseLoginHelperCallback
    var parseLoginHelper: ParseLoginHelper!
    var window: UIWindow?
    
    init(callback: ParseLoginHelperCallback) {
        self.callback = callback
    }
}

extension ParseLoginHelper : PFLogInViewControllerDelegate {
    
    
    func logInViewController(logInController: PFLogInViewController, didLogInUser user: PFUser) {
        let isFacebookLogin = FBSDKAccessToken.currentAccessToken() != nil
        
        if !isFacebookLogin {
            self.callback(user, nil)

            
        } else {
            FBSDKGraphRequest(graphPath: "me", parameters: nil).startWithCompletionHandler {
                (connection: FBSDKGraphRequestConnection!, result: AnyObject?, error: NSError?) -> Void in
                if let error = error {
                    self.callback(nil, error)
                }
                
                if let fbUsername = result?["name"] as? String {
                    user.username = fbUsername
                    user.saveInBackgroundWithBlock({ (success, error) -> Void in
                        if (success) {
                            self.callback(user, error)
                        } else {
                            self.callback(nil, error)
                        }
                    })
                    
                } else {
                   
                    self.callback(nil, error)
                }
            }
        }
    }
    
}

extension ParseLoginHelper : PFSignUpViewControllerDelegate {
    
    func signUpViewController(signUpController: PFSignUpViewController, didSignUpUser user: PFUser) {
        
        signUpController.minPasswordLength = 6
        
        let storyboard = UIStoryboard(name: "Main", bundle: nil)
        let tabBarController = storyboard.instantiateViewControllerWithIdentifier("TabBarController")
        signUpController.presentViewController(tabBarController, animated:true, completion:nil)
        self.callback(user,nil)
        

    }
}