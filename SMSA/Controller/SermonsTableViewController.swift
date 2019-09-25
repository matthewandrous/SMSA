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
        SermonsModel.sermonsModel.test()
    }

    override func numberOfSections(in tableView: UITableView) -> Int {
        return 1
    }
    
    override func tableView(_ tableView: UITableView, numberOfRowsInSection section: Int) -> Int {
        return SermonsModel.sermonsModel.sermonList.count
    }
    
    override func tableView(_ tableView: UITableView, cellForRowAt indexPath: IndexPath) -> SermonTableViewCell {
        let cell = tableView.dequeueReusableCell(withIdentifier: "Sermon", for: indexPath) as! SermonTableViewCell
        var x = (SermonsModel.sermonsModel.sermonList[indexPath.row]["title"] as! String)
        var y = x.components(separatedBy: "|")
        
        cell.titleLabel!.text = y[0]
        cell.descriptionLabel!.text = y[1]
        return cell
    }
    
    override func tableView(_ tableView: UITableView, didSelectRowAt indexPath: IndexPath) {
        showTutorial(indexPath.row)
        tableView.cellForRow(at: indexPath)?.accessoryType = .detailButton
    }
    
    
    func showTutorial(_ which: Int) {
        SermonsModel.sermonsModel.selectSermon(index: which)
        let storyBoard: UIStoryboard = UIStoryboard(name: "Main", bundle: nil)
        let newViewController = storyBoard.instantiateViewController(withIdentifier: "NowPlayingVC")
        newViewController.modalPresentationStyle = .popover
        self.present(newViewController, animated: true, completion: nil)
    }

}

