//
//  Company.swift
//  Feed Me!
//
//  Created by Administrator on 7/19/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import UIKit

class Company {
    
    var name: String
    var photo: UIImage?
    var about: String
    
    // MARK: Initialization
    
    init(name: String, photo: UIImage?, about: String) {
        // Initialize stored properties.
        self.name = name
        self.photo = photo
        self.about = about
        
    }
}