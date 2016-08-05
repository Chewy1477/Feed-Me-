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
import CorePlot


class UserViewController: UIViewController {
    
    var imagePickerController: UIImagePickerController?
    var photoTakingHelper: PhotoTakingHelper?
    var image: UIImage?
    let user = PFUser.currentUser()
    var menuView: BTNavigationDropdownMenu!
    var window: UIWindow?
    var parseLoginHelper: ParseLoginHelper!
    
    @IBOutlet weak var hostView: CPTGraphHostingView!
    
    @NSManaged var imageFile: PFFile?

    @IBOutlet weak var imagePicker: UIImageView!


    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var displayAge: UILabel!
    @IBOutlet weak var displayMusic: UILabel!
    
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
        
        let menuView = BTNavigationDropdownMenu(navigationController: self.navigationController, containerView: self.navigationController!.view, title: items[0], items: items)
        
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
            case "About":
                let about = self.storyboard!.instantiateViewControllerWithIdentifier("AboutViewController")
                self.presentViewController(about, animated: true, completion: nil)
            case "Profile":
                let profile = self.storyboard?.instantiateViewControllerWithIdentifier("ProfileViewController")
                self.presentViewController(profile!, animated: true, completion: nil)
            case "Sign Out":
                self.signOut()
            default:
                break
            }
        }

        // Do any additional setup after loading the view, typically from a nib.
        self.imagePicker.layer.borderWidth = 3
        self.imagePicker.layer.borderColor = UIColor(red:100/255.0, green:225/255.0, blue:227/255.0, alpha: 1.0).CGColor
        
        self.imagePicker.layer.cornerRadius = self.imagePicker.frame.size.width / 2;
        self.imagePicker.clipsToBounds = true
        
        imagePicker.userInteractionEnabled = true
        
        let singleTap: UITapGestureRecognizer = UITapGestureRecognizer(target: self, action: #selector(UserViewController.getPhoto(_:)))
        singleTap.numberOfTapsRequired = 1;
        imagePicker.addGestureRecognizer(singleTap)
        
        
        self.fetchImage()
        self.retrieveText()
    }
    
    override func viewDidLayoutSubviews() {
        super.viewDidLayoutSubviews()
        initPlot()
    }
    
    func initPlot() {
        configureHostView()
        configureGraph()
        configureChart()
        configureLegend()
    }
    
    func configureHostView() {
        hostView.allowPinchScaling = false

    }
    
    func configureGraph() {
        let graph = CPTXYGraph(frame: hostView.bounds)
        hostView.hostedGraph = graph
        graph.paddingLeft = 0.0
        graph.paddingTop = 0.0
        graph.paddingRight = 0.0
        graph.paddingBottom = 0.0
        graph.axisSet = nil
        
        // 2 - Create text style
        let textStyle: CPTMutableTextStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.blackColor()
        textStyle.fontName = "HelveticaNeue-Bold"
        textStyle.fontSize = 16.0
        textStyle.textAlignment = .Center
        
        // 3 - Set graph title and text style
        graph.title = "Total Donations"
        graph.titleTextStyle = textStyle
        graph.titlePlotAreaFrameAnchor = CPTRectAnchor.Top
    }
    
    func configureChart() {
    }
    
    func configureLegend() {
    }
    
    override func viewDidAppear(animated: Bool) {
        super.viewDidAppear(animated)
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
    
   

    func retrieveText() {
        guard let nameGet = (user?["Name"] as! String?), ageGet = (user?["Age"] as! String?), musicGet = (user?["Music"] as! String?)  else {
            return
        }
        self.displayName.text = nameGet
        self.displayAge.text = ageGet
        self.displayMusic.text = musicGet
        
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

}

extension UserViewController: CPTPieChartDataSource, CPTPieChartDelegate {
    
    func numberOfRecordsForPlot(plot: CPTPlot) -> UInt {
        return 0
    }
    
    func numberForPlot(plot: CPTPlot, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject? {
        return 0
    }
    
    func dataLabelForPlot(plot: CPTPlot, recordIndex idx: UInt) -> CPTLayer? {
        return nil
    }
    
    func sliceFillForPieChart(pieChart: CPTPieChart, recordIndex idx: UInt) -> CPTFill? {
        return nil
    }
    
    func legendTitleForPieChart(pieChart: CPTPieChart, recordIndex idx: UInt) -> String? {
        return nil
    }  
}
