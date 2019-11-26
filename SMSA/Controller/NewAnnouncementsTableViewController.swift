//
//  NewAnnouncementsTableViewController.swift
//  SMSA
//
//  Created by Matthew Androus on 9/20/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

import UIKit
import WebKit
import SafariServices

class NewAnnouncementsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        //tableView.register(UINib(nibName: "AnnouncementCell", bundle: nil), forCellReuseIdentifier: "AnnouncementCell")
        AnnouncementsModel.announcementsModel.test()

        // Uncomment the following line to preserve selection between presentations
        // self.clearsSelectionOnViewWillAppear = false

        // Uncomment the following line to display an Edit button in the navigation bar for this view controller.
        // self.navigationItem.rightBarButtonItem = self.editButtonItem
        
        /* Create our preferences on how the web page should be loaded */
        let preferences = WKPreferences()
        preferences.javaScriptEnabled = false
        
        /* Create a configuration for our preferences */
        let configuration = WKWebViewConfiguration()
        configuration.preferences = preferences
        
        //iCalParser.icp.doNothing()
        //SermonsModel.sermonsModel.test()
        
        DispatchQueue.global().async {
            iCalParser.icp.doNothing()
            DispatchQueue.main.async {
                //nothing
            }
        }
        
        //starting Sermons parsing in a seperate thread
        DispatchQueue.global().async {
            SermonsModel.sermonsModel.test()
            DispatchQueue.main.async {
                //nothing
            }
        }
    }
    
    
    override func viewDidAppear(_ animated: Bool) {
        super.viewDidAppear(animated)
        if let index = self.tableView.indexPathForSelectedRow{
            self.tableView.deselectRow(at: index, animated: true)
            print("hello")
        }
    }

    // MARK: - Table view data source


    
    override func numberOfSections(in tableView: UITableView) -> Int {
//        print("IN numberOfSection()")
        //return one section because we only have one section
        //this was a dumb comment in retrospect
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnnouncementsModel.announcementsModel.announcementList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Announcement", for: indexPath) as! AnnouncementCell
        
        cell.announcementTitle?.text = AnnouncementsModel.announcementsModel.announcementList[indexPath.row]["title"] as? String
        
        if AnnouncementsModel.announcementsModel.announcementList[indexPath.row]["tag"] as! String == "HS" {
//            print("CHANGING IMAGE")
            cell.announcementImage?.image = #imageLiteral(resourceName: "CrossGreen")
        }
        else if AnnouncementsModel.announcementsModel.announcementList[indexPath.row]["tag"] as! String == "JHB" {
//            print("CHANGING IMAGE")
            cell.announcementImage?.image = #imageLiteral(resourceName: "CrossBlue")
        }
        else if AnnouncementsModel.announcementsModel.announcementList[indexPath.row]["tag"] as! String == "JHG" {
//            print("CHANGING IMAGE")
            cell.announcementImage?.image = #imageLiteral(resourceName: "CrossPurple")
        }
        else if AnnouncementsModel.announcementsModel.announcementList[indexPath.row]["tag"] as! String == "ELEM" {
//            print("CHANGING IMAGE")
            cell.announcementImage?.image = #imageLiteral(resourceName: "CrossYellow")
        }
        else {
//            print("DEFAULT IMAGE")
            cell.announcementImage?.image = #imageLiteral(resourceName: "CrossRed")
        }
        cell.accessoryType = .disclosureIndicator
        
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTutorial(indexPath.row)
    }
    
    func showTutorial(_ which: Int) {
           if let url = URL(string: (AnnouncementsModel.announcementsModel.announcementList[which]["link"] as? String)!) {
               let config = SFSafariViewController.Configuration()

               let vc = SFSafariViewController(url: url, configuration: config)
               present(vc, animated: true) /*{
                   var frame = vc.view.frame
                   let OffsetY: CGFloat  = 535
                   frame.origin = CGPoint(x: frame.origin.x, y: frame.origin.y - OffsetY)
                   frame.size = CGSize(width: frame.width, height: frame.height + OffsetY)
                   vc.view.frame = frame
               } */
           }
       }
    
    
    
    
    
    
    
    /*
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "reuseIdentifier", for: indexPath)

        // Configure the cell...

        return cell
    }
    */

    /*
    // Override to support conditional editing of the table view.
    override func tableView(_ tableView: UITableView, canEditRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the specified item to be editable.
        return true
    }
    */

    /*
    // Override to support editing the table view.
    override func tableView(_ tableView: UITableView, commit editingStyle: UITableViewCell.EditingStyle, forRowAt indexPath: IndexPath) {
        if editingStyle == .delete {
            // Delete the row from the data source
            tableView.deleteRows(at: [indexPath], with: .fade)
        } else if editingStyle == .insert {
            // Create a new instance of the appropriate class, insert it into the array, and add a new row to the table view
        }    
    }
    */

    /*
    // Override to support rearranging the table view.
    override func tableView(_ tableView: UITableView, moveRowAt fromIndexPath: IndexPath, to: IndexPath) {

    }
    */

    /*
    // Override to support conditional rearranging of the table view.
    override func tableView(_ tableView: UITableView, canMoveRowAt indexPath: IndexPath) -> Bool {
        // Return false if you do not want the item to be re-orderable.
        return true
    }
    */

    /*
    // MARK: - Navigation

    // In a storyboard-based application, you will often want to do a little preparation before navigation
    override func prepare(for segue: UIStoryboardSegue, sender: Any?) {
        // Get the new view controller using segue.destination.
        // Pass the selected object to the new view controller.
    }
    */

}
