//
//  AboutViewController.swift
//  Feed Me!
//
//  Created by Administrator on 8/4/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import Foundation
import UIKit

class AboutViewController: UIViewController {
    
    @IBOutlet weak var aboutImage: UIImageView!
    @IBOutlet weak var goalLabel: UILabel!
    @IBOutlet weak var goalText: UITextView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180.0/255.0, blue:220.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        aboutImage.image = UIImage(named: "stats")
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}