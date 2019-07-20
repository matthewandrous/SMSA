//
//  FirstViewController.swift
//  SMSA
//
//  Created by Matthew Androus on 7/19/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

import UIKit

class AnnouncementsViewController: UIViewController, UITableViewDataSource, UITableViewDelegate {
    
//    let announcement: AnnouncementCell? = nil
    
    @IBOutlet weak var announcementsTableView: UITableView!
    
    override func viewDidLoad() {
        super.viewDidLoad()
        
        AnnouncementsModel.announcementsModel.test()
        
        guard let url = URL(string: "https://www.googleapis.com/calendar/v3/calendars/st-athanasius.org_uiq2ebabvqqh1jvf5uv7maa6pc@group.calendar.google.com") else {return}
        let task = URLSession.shared.dataTask(with: url) { (data, response, error) in
            guard let dataResponse = data,
                error == nil else {
                    print(error?.localizedDescription ?? "Response Error")
                    return }
            do{
                //here dataResponse received from a network request
                let jsonResponse = try JSONSerialization.jsonObject(with:
                    dataResponse, options: [])
                print(jsonResponse) //Response result
            } catch let parsingError {
                print("Error", parsingError)
            }
        }
        task.resume()
        
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
        return 4
    }
    
    func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        
        let cell = tableView.dequeueReusableCell(withIdentifier: "Announcement", for: indexPath) as! AnnouncementCell
        
        cell.announcementTitle?.text = AnnouncementsModel.announcementsModel.announcementList[indexPath.row]["title"] as! String
        
        return cell
    }
    
    

    


}

