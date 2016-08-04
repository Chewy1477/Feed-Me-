//
//  UserViewController.swift
//  Feed Me!
//
//  Created by Administrator on 7/12/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import UIKit
import Parse
import BTNavigationDropdownMenu


class UserViewController: UIViewController, UITextFieldDelegate {
    
    var imagePickerController: UIImagePickerController?
    var photoTakingHelper: PhotoTakingHelper?
    var image: UIImage?
    let user = PFUser.currentUser()
    var menuView: BTNavigationDropdownMenu!
    var window: UIWindow?
    var parseLoginHelper: ParseLoginHelper!
    
    @NSManaged var imageFile: PFFile?

    @IBOutlet weak var nameLabel: UITextField!
    @IBOutlet weak var imagePicker: UIImageView!
    @IBOutlet weak var ageLabel: UITextField!
    @IBOutlet weak var descriptionLabel: UITextField!

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

        
        let items = ["Home", "About", "Profile", "Sign Out"]
        
        self.navigationController?.navigationBar.translucent = false
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180/255.0, blue:220/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName: UIColor.whiteColor()]
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: "Hello!", items: items)
        
        menuView.cellHeight = 50
        menuView.cellBackgroundColor = self.navigationController?.navigationBar.barTintColor
        menuView.cellSelectionColor = UIColor(red: 0.0/255.0, green:160.0/255.0, blue:195.0/255.0, alpha: 1.0)
        menuView.cellTextLabelColor = UIColor.whiteColor()
        menuView.cellTextLabelFont = UIFont(name: "Avenir-Heavy", size: 17)
        menuView.cellTextLabelAlignment = .Left // .Center // .Right // .Left
        menuView.arrowPadding = 15
        menuView.animationDuration = 0.5
        menuView.maskBackgroundColor = UIColor.blackColor()
        menuView.maskBackgroundOpacity = 0.3
        
        self.navigationItem.titleView = menuView

        menuView.didSelectItemAtIndexHandler = {(indexPath: Int) -> () in
            switch items[indexPath] {
            case "Home":
                self.dismissViewControllerAnimated(true, completion: nil)
            case "About":
                let about = self.storyboard?.instantiateViewControllerWithIdentifier("AboutViewController")
                self.presentViewController(about!, animated: true, completion: nil)
            case "Profile":
                let profile = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController")
                self.presentViewController(profile!, animated: true, completion: nil)
            case "Sign Out":
                self.signOut()
            default:
                break
            }
        }
    

        self.nameLabel.delegate = self
        self.ageLabel.delegate = self
        self.descriptionLabel.delegate = self
        
        // Do any additional setup after loading the view, typically from a nib.
        self.imagePicker.layer.borderWidth = 3
        self.imagePicker.layer.borderColor = UIColor(red:100/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        
        self.imagePicker.layer.cornerRadius = self.imagePicker.frame.size.width / 2;
        self.imagePicker.clipsToBounds = true
        
        imagePicker.userInteractionEnabled = true
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserViewController.getPhoto(_:)))
        singleTap.numberOfTapsRequired = 1;
        imagePicker.addGestureRecognizer(singleTap)
        
        IconHelper.createIcon(nameLabel, image: "Dog Tag-50")
        IconHelper.createIcon(ageLabel, image: "Age-50")
        IconHelper.createIcon(descriptionLabel, image: "About-50")

        
        self.fetchImage()
        self.retrieveText()
    }
    
    func signOut() {
        let returnViewController = LoginViewController()
        
        returnViewController.fields = [.UsernameAndPassword, .LogInButton, .SignUpButton, .PasswordForgotten, .Facebook]
        returnViewController.delegate = parseLoginHelper
        returnViewController.signUpController?.delegate = parseLoginHelper
        
        PFUser.logOut()
        
        self.window = UIWindow(frame: UIScreen.mainScreen().bounds)
        self.window?.rootViewController = returnViewController
        self.window?.makeKeyAndVisible()

    }
   
    func textFieldShouldReturn(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func didTapView(textField: UITextField) -> Bool {
        self.view.endEditing(true)
        return false
    }
    
    func getPhoto(recognizer: UIGestureRecognizer) {
        takePhoto()

    }

    
    func takePhoto() {
        // instantiate photo taking class, provide callback for when photo is selected
        photoTakingHelper = PhotoTakingHelper(viewController: self.tabBarController!) { (image: UIImage?) in
            
            self.imagePicker.image = image
            self.image = image
            self.uploadImage()
        }
    }
    
    func saveText() {
        let nameSave = self.nameLabel.text
        let ageSave = self.ageLabel.text
        let descriptionSave = self.descriptionLabel.text
        
        user!.setObject(nameSave!, forKey: "Name")
        user!.setObject(ageSave!, forKey: "Age")
        user!.setObject(descriptionSave!, forKey: "Description")
        user!.saveInBackgroundWithBlock(nil)
        
    }

    func retrieveText() {
        guard let nameGet = (user?["Name"] as! String?), ageGet = (user?["Age"] as! String?), descriptionGet = (user?["Description"] as! String?)  else {
            return
        }

        self.nameLabel.text = nameGet
        self.ageLabel.text = ageGet
        self.descriptionLabel.text = descriptionGet
        
    }

    
    func uploadImage() {
        if let image = image {
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
            
            
            user!.setObject(imageFile, forKey: "imageFile")
            user!.saveInBackgroundWithBlock(nil)
        }
    }
    
    func fetchImage() {
        if let userPicture = user?["imageFile"] as? PFFile {
            userPicture.getDataInBackgroundWithBlock { (imageData: NSData?, error: NSError?) -> Void in
                if (error == nil) {
                    self.imagePicker.image = UIImage(data: imageData!)
                }
            }
        }
        else {
            self.imagePicker.image = UIImage(named: "face")
        }

    }
            
    @IBAction func saveFields(sender: UIButton) {
        self.saveText()

    }
}
