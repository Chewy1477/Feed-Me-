//
//  CompanyNotesTableViewController.swift
//  Feed Me!
//
//  Created by Administrator on 7/19/16.
//  Copyright © 2016 Chris Chueh. All rights reserved.
//

import UIKit

class CompanyNotesTableViewController: UITableViewController {
    
    var companies = [Company]()
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        loadCompanies()
        
    }
    func loadCompanies() {
        let panera = UIImage(named: "panera-logo")
        let createPanera = Company(name: "Panera Bread", photo: panera, about: "American chain of bakery-café restaurants." )
        
        let pizzaHut = UIImage(named: "Pizza Hut")
        let createPizza = Company(name: "Pizza Hut", photo: pizzaHut, about: "American restaurant chain known for Italian-American cuisine.")
        
        companies += [createPanera, createPizza, createPizza,createPizza,createPizza,createPizza,createPizza,createPizza,createPizza,createPizza]
    }

    override func tableView(tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return companies.count
    }
    
    override func numberOfSectionsInTableView(tableView: UITableView) -> Int {
        return 1
    }
    
    // 2
    override func tableView(tableView: UITableView, cellForRowAtIndexPath indexPath: NSIndexPath) -> UITableViewCell {
        // 3
        let cell = tableView.dequeueReusableCellWithIdentifier("CompanyNotesTableViewCell", forIndexPath: indexPath) as! CompanyNotesTableViewCell
        
        // 4
        let company = companies[indexPath.row]
        cell.nameLabel.text = company.name
        cell.photoView.image = company.photo
        cell.aboutText.text = company.about
        
        

        // 5
        return cell
    }
 
}

