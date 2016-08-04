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
    }
    
    @IBAction func backButton(sender: UIButton) {
        self.dismissViewControllerAnimated(true, completion: nil)
    }
    
}