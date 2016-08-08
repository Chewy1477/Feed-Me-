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
    var searchName: String?
 
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        self.navigationController?.navigationBar.barTintColor = UIColor(red: 0.0/255.0, green:180.0/255.0, blue:220.0/255.0, alpha: 1.0)
        self.navigationController?.navigationBar.titleTextAttributes = [NSForegroundColorAttributeName:UIColor.whiteColor()]
        
        loadCompanies()
        
    }
    func loadCompanies() {
        let panera = UIImage(named: "panera-logo")
        let createPanera = Company(name: "Panera Bread", photo: panera, about: "American chain of bakery-café restaurants." )
        
        let pizzaHut = UIImage(named: "Pizza Hut")
        let createPizza = Company(name: "Pizza Hut", photo: pizzaHut, about: "American restaurant chain known for Italian-American cuisine.")
        
        let dominoes = UIImage(named: "dominoes")
        let createDominoes = Company(name: "Dominoes", photo: dominoes, about: "Second largest pizza franchise after Pizza Hut.")
        
        companies += [createPanera, createPizza, createDominoes]
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
        
        
        cell.accessoryView = UIImageView(image: UIImage(named: "More Than-50")!)

        // 4
        let company = companies[indexPath.row]

        cell.nameLabel.text = company.name
        cell.photoView.image = company.photo
        cell.aboutLabel.text = company.about
        
        
        // 5
        return cell
    }
    
    override func tableView(tableView: UITableView, didSelectRowAtIndexPath indexPath: NSIndexPath) {
        let company = companies[indexPath.row]
        NSUserDefaults.standardUserDefaults().setObject(company.name, forKey: "companyName")
    }
 
}

