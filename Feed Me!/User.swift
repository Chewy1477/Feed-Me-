//
//  User.swift
//  Feed Me!
//
//  Created by Administrator on 7/18/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import Foundation
import Parse

// 1
class User : PFObject, PFSubclassing {
    
    var image: UIImage?

    
    // 2
    @NSManaged var imageFile: PFFile?
    @NSManaged var user: PFUser?
    
    func uploadImage() {
        if let image = image {
            guard let imageData = UIImageJPEGRepresentation(image, 0.8) else {return}
            guard let imageFile = PFFile(name: "image.jpg", data: imageData) else {return}
            user = PFUser.currentUser()

            self.imageFile = imageFile
            saveInBackgroundWithBlock(nil)
        }
    }
    
    // 3
    static func parseClassName() -> String {
        return "User"
    }
    
    // 4
    override init () {
        super.init()
    }
    
    override class func initialize() {
        var onceToken : dispatch_once_t = 0;
        dispatch_once(&onceToken) {
            // inform Parse about this subclass
            self.registerSubclass()
        }
    }
    
}