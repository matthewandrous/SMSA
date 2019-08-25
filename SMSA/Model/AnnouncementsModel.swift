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
    let announcementTags = ["HS", "JHB", "JHG", "ELEM"]
    
    private init(){
//        print("hello world")
    }
    
    func fetchAnnouncements(){
        
        
        fetchAllAnnouncements() //even tagged announcements will be fetched here, but with no tag
        fetchAnnouncementsWithTag(tag: "HS")
        fetchAnnouncementsWithTag(tag: "JHB")
        fetchAnnouncementsWithTag(tag: "JHG")
        fetchAnnouncementsWithTag(tag: "ELEM")
        
        
        announcementList.sort { ($0["pubDate"]! as! Date) > ($1["pubDate"]! as! Date) }
        removeDuplicates()
    }
    
    //since we know duplicates will always be back to back after being sorted
    //we don't need a nested for-loop– we just need to check elements next to each other
    //keeping our run-time at n
    func removeDuplicates(){
        for i in 0...announcementList.count-1{
//            print(i, i-1)
            if(i != 0){
                if announcementList[i]["title"] as! String == announcementList[i-1]["title"] as! String{
                    //delete the one that occurs first, since that will be the one without the tag
                    announcementList[i-1]["title"] = nil //we don't actually delete them because we are iterating over the array (more below)
                }
            }
        }
        
        //delete them here (Apple reccomends removeAll as you can avoid
        //reversing arrays and because it's faster than filter
        announcementList.removeAll(where: {$0["title"] == nil})
    }
    
    func fetchAnnouncementsWithTag(tag: String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyy HH:mm:ss Z"
        
        let myparser = RSSParser()
        myparser.initWithURL(URL(string: "https://www.st-athanasius.org/blogat?tag=" + tag + "&format=rss")!)
        //myparser.initWithURL(URL(string: "https://www.st-athanasius.org/blogat?format=rss")!)
//        print(myparser.feeds.count)

        for feed  in myparser.feeds {
            var myfeed = feed as! [String:String]
            var currAnnouncement = [String:Any]()
            currAnnouncement["title"] = myfeed["title"]
            currAnnouncement["link"] = myfeed["link"]
            currAnnouncement["description"] = myfeed["description"]
            currAnnouncement["pubDate"] = dateFormatter.date(from: (myfeed["pubDate"]!) )
//            print(currAnnouncement["pubDate"]!)
            currAnnouncement["tag"] = tag

            announcementList.append(currAnnouncement)
        }
    }
    
    func fetchAllAnnouncements(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyy HH:mm:ss Z"
        
        let myparser = RSSParser()
        myparser.initWithURL(URL(string: "https://www.st-athanasius.org/blogat?format=rss")!)
        //myparser.initWithURL(URL(string: "https://www.st-athanasius.org/blogat?format=rss")!)
//        print(myparser.feeds.count)
        
        for feed  in myparser.feeds {
            var myfeed = feed as! [String:String]
            var currAnnouncement = [String:Any]()
            currAnnouncement["title"] = myfeed["title"]
            currAnnouncement["link"] = myfeed["link"]
            currAnnouncement["description"] = myfeed["description"]
            currAnnouncement["pubDate"] = dateFormatter.date(from: (myfeed["pubDate"]!) )
//            print(currAnnouncement["pubDate"]!)
            currAnnouncement["tag"] = "none"
            
            announcementList.append(currAnnouncement)
        }
    }
    
    func test(){
        fetchAnnouncements()
    }
}

