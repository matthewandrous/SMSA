//
//  FirstViewController.swift
//  SMSA
//
//  Created by Matthew Androus on 7/19/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

import UIKit
import SafariServices

class AnnouncementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
    @IBOutlet weak var announcementsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AnnouncementsModel.announcementsModel.test()
        announcementsTableView.delegate = self
        announcementsTableView.dataSource = self
    }
    
    func numberOfSections(in tableView: UITableView) -> Int {
        print("IN numberOfSection()")
        //return one section because we only have one section
        //this was a dumb comment in retrospect
        return 1
    }
    
    func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return AnnouncementsModel.announcementsModel.announcementList.count
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Announcement", for: indexPath) as! AnnouncementCell
        
        cell.announcementTitle?.text = AnnouncementsModel.announcementsModel.announcementList[indexPath.row]["title"] as? String
        
        cell.announcementImage?.image = #imageLiteral(resourceName: "CrossRed")
        cell.accessoryType = .disclosureIndicator
        
        return cell
    }
    
    func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
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
}

