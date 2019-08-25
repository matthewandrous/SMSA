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
        iCalParser.icp.doNothing()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iCalParser.icp.upcomingEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        var cell: UITableViewCell = UITableViewCell()
        var temp = iCalParser.icp.upcomingEventsWithDates[indexPath.row]
        if (temp["type"] as! String == "date") {
            var dateCell = CalendarHeaderCell()
            dateCell = tableView.dequeueReusableCell(withIdentifier: "Header", for: indexPath) as! CalendarHeaderCell
            dateCell.weekDayLabel.text = (temp["day"] as! String)
            dateCell.monthDayLabel.text = temp["date"] as! String
            return dateCell
        } else if (temp["type"] as! String == "event") {
            var eventCell = EventTableViewCell()
            eventCell = tableView.dequeueReusableCell(withIdentifier: "Event", for: indexPath) as! EventTableViewCell
            eventCell.eventName.text = temp["calName"] as! String
            eventCell.eventTime.text = String((temp["start"] as! String) + "–" + (temp["end"] as! String))
            
            return eventCell
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
