//
//  IconHelper.swift
//  Feed Me!
//
//  Created by Administrator on 8/3/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import Foundation
import UIKit

class IconHelper {

    static func createIcon(text: UITextField, image: String) {
        let imageView = UIImageView(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
        let selected = UIImage(named: image)
        imageView.image = selected
        text.leftView = imageView
        text.leftViewMode = UITextFieldViewMode.Always
        
    }
}

