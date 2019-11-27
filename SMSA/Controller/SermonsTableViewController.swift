//
//  SecondViewController.swift
//  SMSA
//
//  Created by Matthew Androus on 7/19/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

import UIKit
import SafariServices
import WebKit

class SermonsTableViewController: UITableViewController {

    override func viewDidLoad() {
        super.viewDidLoad()
        // Do any additional setup after loading the view.
        //SermonsModel.sermonsModel.test()
        tableView.estimatedRowHeight = 85.0
        tableView.rowHeight = UITableView.automaticDimension
        DataManager.shared.SermonsTVC = self
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SermonsModel.sermonsModel.sermonList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> UITableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Sermon", for: indexPath)
        var x = (SermonsModel.sermonsModel.sermonList[indexPath.row]["title"] as! String)
        var y = x.components(separatedBy: "|")
        
//        cell.titleLabel!.text = y[0]
//        cell.descriptionLabel!.text = y[1]
        
        cell.textLabel?.text = y[0]
        cell.detailTextLabel?.text = y[1]
        
        cell.accessoryView = nil
        print("nope")
        if (SermonsModel.sermonsModel.sermonList[indexPath.row]["inProgress"] as! Bool){
//            cell.accessoryType = .disclosureIndicator
            print("found it")
            let font = UIFont(name: "icomoon", size: 50.0)
            let icon = "\u{25B6}"
 
            let lbl = UILabel(frame: CGRect(x: 0, y: 0, width: 20, height: 20))
            lbl.font = font
            lbl.text = icon
            lbl.textColor =  UIColor.red
//            cell.accessoryView?.frame = CGRect(x: 0, y: 0, width: 30, height: 30)
            cell.accessoryView = lbl
            cell.tintColor = UIColor.red
        }
        
        
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTutorial(indexPath.row)
    }
    
    
    func showTutorial(_ which: Int) {
        SermonsModel.sermonsModel.selectSermon(index: which)
        tableView.reloadData()
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NowPlayingVC")
        newViewController.modalPresentationStyle = .popover
        self.present(newViewController, animated: true, completion: nil)
    }
    
    func deselectTableView() {
        DispatchQueue.main.async {
            if let index = self.tableView.indexPathForSelectedRow{
                self.tableView.deselectRow(at: index, animated: true)
            }
        }
    }

}

