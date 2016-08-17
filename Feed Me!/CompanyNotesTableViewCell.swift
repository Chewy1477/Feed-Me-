//
//  CompanyNotesTableViewCell.swift
//  Feed Me!
//
//  Created by Administrator on 7/19/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import UIKit

class CompanyNotesTableViewCell: UITableViewCell {
    
    
    @IBOutlet weak var aboutLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    @IBOutlet weak var nameLabel: UILabel!
    
    
    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected,animated: animated)

    }
   
    
}
