//
//  AnnouncmentsModel.swift
//  AnnouncementParser
//
//  Created by Matthew Androus on 7/19/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

import Foundation
class AnnouncementsModel {
    
    
    static let announcementsModel = AnnouncementsModel.init()
    var announcementList = [[String:Any]]()
    
    private init(){
        print("hello world")
    }
    
    
    func test(){
        print ("test")
        let myparser = RSSParser()
        myparser.initWithURL(URL(string: "https://www.st-athanasius.org/announcements?format=rss")!)
        print(myparser.feeds.count)
        
        for feed  in myparser.feeds {
            var myfeed = feed as! NSMutableDictionary
            var currAnnouncement = [String:Any]()
            currAnnouncement["title"] = myfeed["title"]
            currAnnouncement["link"] = myfeed["lin"]
            currAnnouncement["description"] = myfeed["description"]
            currAnnouncement["pubDate"] = myfeed["pubDate"]
            
            announcementList.append(currAnnouncement)
        }
        
        for announcement in announcementList {
            print(announcement["title"]!)
        }
    }
}

