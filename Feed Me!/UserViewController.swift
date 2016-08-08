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
    var graphSlices: [Slice]!
    var donations: [String: NSNumber] = [:]
    
    @IBOutlet weak var hostView: CPTGraphHostingView!
    
    @NSManaged var imageFile: PFFile?

    @IBOutlet weak var imagePicker: UIImageView!


    @IBOutlet weak var displayName: UILabel!
    @IBOutlet weak var displayAge: UILabel!
    @IBOutlet weak var displayFood: UILabel!

    
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
        menuView.cellSelectionColor = UIColor(red: 14.0/255.0, green:206.0/255.0, blue:251.0/255.0, alpha: 1.0)
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
        self.imagePicker.layer.borderColor = UIColor(red: 14.0/255.0, green:206.0/255.0, blue:251.0/255.0, alpha: 1.0).CGColor
        
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
        let graph = hostView.hostedGraph!
        
        // 2 - Create the chart
        let pieChart = CPTPieChart()
        pieChart.delegate = self
        pieChart.dataSource = self
        pieChart.pieRadius = (min(hostView.bounds.size.width, hostView.bounds.size.height) * 0.7) / 2
        pieChart.identifier = graph.title
        pieChart.startAngle = CGFloat(M_PI_4)
        pieChart.sliceDirection = .Clockwise
        pieChart.labelOffset = -0.6 * pieChart.pieRadius
        
        // 3 - Configure border style
        let borderStyle = CPTMutableLineStyle()
        borderStyle.lineColor = CPTColor.whiteColor()
        borderStyle.lineWidth = 2.0
        pieChart.borderLineStyle = borderStyle
        
        // 4 - Configure text style
        let textStyle = CPTMutableTextStyle()
        textStyle.color = CPTColor.whiteColor()
        textStyle.textAlignment = .Center
        pieChart.labelTextStyle = textStyle
        
        // 3 - Add chart to graph
        graph.addPlot(pieChart)
    }
    
    func configureLegend() {
        guard let graph = hostView.hostedGraph else { return }
        
        // 2 - Create legend
        let theLegend = CPTLegend(graph: graph)
        
        // 3 - Configure legend
        theLegend.numberOfColumns = 1
        theLegend.fill = CPTFill(color: CPTColor.whiteColor())
        let textStyle = CPTMutableTextStyle()
        textStyle.fontSize = 18
        theLegend.textStyle = textStyle
        
        // 4 - Add legend to graph
        graph.legend = theLegend
        graph.legendAnchor = .Right
        graph.legendDisplacement = CGPoint(x: 0, y: 0.0)

    
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
        guard let nameGet = (user?["Nickname"] as! String?), ageGet = (user?["Age"] as! String?), foodGet = (user?["Food"] as! String?)  else {
            return
        }
        self.displayName.text = nameGet
        self.displayAge.text = ageGet
        self.displayFood.text = foodGet
        
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
   
    func addValues(parameter: String) -> [String: NSNumber] {
        donations[parameter] = 10
        print(donations)
        return donations
    }

}

extension UserViewController: CPTPieChartDataSource, CPTPieChartDelegate {
    
    func numberOfRecordsForPlot(plot: CPTPlot) -> UInt {
        return 2
    }
    
    func numberForPlot(plot: CPTPlot, field fieldEnum: UInt, recordIndex idx: UInt) -> AnyObject? {
        graphSlices = [Slice(name: "You"), Slice(name: "Total")]
        let getSlice = graphSlices[Int(idx)]
        self.addValues(getSlice.name)
        let display = donations[getSlice.name]!.floatValue
        return display
    }
    
    func dataLabelForPlot(plot: CPTPlot, recordIndex idx: UInt) -> CPTLayer? {
        let value = donations[graphSlices[Int(idx)].name]!.floatValue
        let layer = CPTTextLayer(text: String(format: "\(graphSlices[Int(idx)].name)\n%.2f", value))
        layer.textStyle = plot.labelTextStyle
        return layer
    }
    
    func sliceFillForPieChart(pieChart: CPTPieChart, recordIndex idx: UInt) -> CPTFill? {
        switch idx {
        case 0:   return CPTFill(color: CPTColor(componentRed:14.0/255.0, green:206.0/255.0, blue:251.0/255.0, alpha:1.00))
        case 1:   return CPTFill(color: CPTColor(componentRed: 230.0/255, green:126.0/255.0, blue:34.0/255.0, alpha:1.00))
        default:  return nil
        }
    }

    func legendTitleForPieChart(pieChart: CPTPieChart, recordIndex idx: UInt) -> String? {
        return graphSlices[Int(idx)].name
    }
}


