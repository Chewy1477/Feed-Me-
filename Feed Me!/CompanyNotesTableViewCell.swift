//
//  CompanyNotesTableViewCell.swift
//  Feed Me!
//
//  Created by Administrator on 7/19/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import UIKit

class CompanyNotesTableViewCell: UITableViewCell {
    
    var onButtonTapped : (() -> Void)? = nil


    // MARK: Properties
    
    @IBOutlet weak var aboutText: UITextView!
    @IBOutlet weak var nameLabel: UILabel!
    @IBOutlet weak var photoView: UIImageView!
    


    override func setSelected(selected: Bool, animated: Bool) {
        super.setSelected(selected, animated: animated)

        // Configure the view for the selected state
    }
    
    @IBAction func locateCompany(sender: UIButton) {
        if let onButtonTapped = self.onButtonTapped {
            onButtonTapped()
        }
    }
    
}
