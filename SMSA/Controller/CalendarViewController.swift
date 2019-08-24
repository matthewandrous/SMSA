//
//  CalendarViewController.swift
//  SMSA
//
//  Created by Pavly Habashy on 8/24/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

import UIKit

class CalendarViewController: UITableViewController {
    
    override func viewDidLoad() {
        tableView.rowHeight = UITableView.automaticDimension
        tableView.rowHeight = 75
        tableView.allowsSelection = false
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return 2
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell
        
        if (indexPath.row == 0) {
            cell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! CalendarHeaderCell
        } else {
            cell = tableView.dequeueReusableCell(withIdentifier: "Event", for: indexPath) as! EventTableViewCell
        }
        
        return cell 
    }
    
    override func tableView(_ tableView: UITableView, estimatedHeightForRowAt indexPath: IndexPath) -> CGFloat {
        return UITableView.automaticDimension
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
//        showTutorial(indexPath.row)
    }
}
