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
        
        // Following 2 lines are needed for the Event and Header Cell files under 'View' folder
        tableView.register(UINib(nibName: "HeaderCell", bundle: nil), forCellReuseIdentifier: "HeaderCell")
        tableView.register(UINib(nibName: "EventCell", bundle: nil), forCellReuseIdentifier: "EventCell")
        
        // Hides the lines under the Navigation bar for a cleaner look (like Things)
        self.navigationController?.navigationBar.setValue(true, forKey: "hidesShadow")
        
        // I have lost faith in this line
        tableView.rowHeight = UITableView.automaticDimension
        
        // Just read the line lol
        tableView.allowsSelection = false
        
        // TODO
        //iCalParser.icp.doNothing()
    }
    
    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return iCalParser.icp.upcomingEvents.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell: UITableViewCell = UITableViewCell()
        var temp = iCalParser.icp.upcomingEventsWithDates[indexPath.row]
        
        // Header cell
        if (temp["type"] as! String == "date") {
            let dateCell = tableView.dequeueReusableCell(withIdentifier: "HeaderCell", for: indexPath) as! HeaderCell
            print((temp["day"] as! String))
            dateCell.weekDayLabel.text = (temp["day"] as! String)
            dateCell.monthDayLabel.text = formatDate(dateString: (temp["date"] as? String)!)
            
            return dateCell
        }
        // Event cell
        else if (temp["type"] as! String == "event") {
            var eventCell = EventCell()
            eventCell = tableView.dequeueReusableCell(withIdentifier: "EventCell", for: indexPath) as! EventCell
            eventCell.eventName.text = temp["title"] as? String
            eventCell.eventName.text = eventCell.eventName.text?.replacingOccurrences(of: "\r", with: "", options: NSString.CompareOptions.literal, range: nil)
            eventCell.eventTime.text = String((temp["start"] as! String) + "–" + (temp["end"] as! String))
            
            eventCell.updateConstraints()
            return eventCell
        }
        
        return cell 
    }
    
    // Determine cell height based on type
    override func tableView(_ tableView: UITableView, heightForRowAt indexPath: IndexPath) -> CGFloat {
        
        var temp = iCalParser.icp.upcomingEventsWithDates[indexPath.row]
        
        if (temp["type"] as! String == "date") {
            return 90
        } else  {
            return 60
        }
    }
    
    // Formats date from "yyyy/08/25" to "August 25"
    func formatDate(dateString: String) -> String {
        
        // Grab date
        let dateFormatterGet = DateFormatter()
        dateFormatterGet.dateFormat = "yyyy/MM/dd"
        
        // Format new date
        let dateFormatterPrint = DateFormatter()
        dateFormatterPrint.dateFormat = "MMMM dd"
        
        if let date = dateFormatterGet.date(from: dateString) {
            
            // Remove leading zero
            let str = dateFormatterPrint.string(from: date)
            let array = str.components(separatedBy: " ")
            let numberAsInt = Int(array[1])
            
            return "\(array[0]) \(numberAsInt ?? 0)"
            
        } else {
            print("There was an error decoding the string")
        }
        
        return ""
    }
}


