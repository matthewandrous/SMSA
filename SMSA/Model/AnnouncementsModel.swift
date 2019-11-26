//
//  AnnouncmentsModel.swift
//  AnnouncementParser
//
//  Created by Matthew Androus on 7/19/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

/* This class is the Announcements Data Model.
 It uses the the RSSParser class to parse the Announcement feeds from the website.
 However, it's more complicated than that.
 
 In order to understand why, you need to understand something about Squarespace blogs.
 Blog posts in the blog can be assigned to a tag. However, that tag doesn't show up in
 RSS metadata. So if I pull the RSS feed for a blog page, I can't see which announcements
 are tagged or what those tags are.
 
 However, you can generate a new RSS feed that only includes items with a particular tag.
 
 
 The class begins execution with fetchAnnouncements().
 This first fetches all the Announcements with fetchAllAnnouncements().
 Since squarespace doesn't include tag info, we don't know any of these announcements' tags.
 All of these announcements are added to the announcementList data structure.

 Next, we go through each tag that is used, and fetch the announcements that for that tag.
 We add those announcements to the data structure as well.
 Yes, this means most announcements are added twice.
 
 Next, we sort the list of announcements by published date. This is necessary since we are
 combining multiple RSS feeds into one. If we only ever pulled one feed, this could be omitted.
 
 Lastly, we remove duplicate announcements.
 Since we have sorted by date, all duplicate announcements will always be next to each other in
 the data structure. This helps us avoid an O(n^2) run time.
 The announcement without the tag is always the one that is deleted.
 */
import Foundation

class AnnouncementsModel {
    
    
    static let announcementsModel = AnnouncementsModel.init()
    var announcementList = [[String:Any]]()
    let announcementTags = ["HS", "JHB", "JHG", "ELEM"]
    
    private init(){
    }
    
    
    /// This function pull all the announcements, and then pulls all tagged announcements sequentially, then sorts and deletes duplicates.
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
    //keeping our run-time at O(n)
    func removeDuplicates(){
        for i in 0...announcementList.count-1{
            if(i != 0){
                if announcementList[i]["title"] as! String == announcementList[i-1]["title"] as! String{
                    //delete the one that occurs first, since that will be the one without the tag
                    announcementList[i-1]["title"] = nil //we don't actually delete them because we are iterating over the array (more below)
                }
            }
        }
        
        /// delete them here (Apple reccomends removeAll as you can avoid reversing arrays, and because it's faster than filter)
        announcementList.removeAll(where: {$0["title"] == nil})
    }
    
    /// This pulls all the announcements that have a particular tag, and adds them to the ``announcementList`` data structure
    /// - Parameter tag: the tag you want to pull
    func fetchAnnouncementsWithTag(tag: String){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyy HH:mm:ss Z"
        
        let myparser = RSSParser()
        myparser.initWithURL(URL(string: "https://www.st-athanasius.org/announcements?tag=" + tag + "&format=rss")!)

        for feed  in myparser.feeds {
            var myfeed = feed as! [String:String]
            var currAnnouncement = [String:Any]()
            currAnnouncement["title"] = myfeed["title"]
            currAnnouncement["link"] = myfeed["link"]
            currAnnouncement["description"] = myfeed["description"]
            currAnnouncement["pubDate"] = dateFormatter.date(from: (myfeed["pubDate"]!) )
            currAnnouncement["tag"] = tag

            announcementList.append(currAnnouncement)
        }
    }
    
    func fetchAllAnnouncements(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyy HH:mm:ss Z"
        
        let myparser = RSSParser()
        myparser.initWithURL(URL(string: "https://www.st-athanasius.org/announcements?format=rss")!)
        
        for feed  in myparser.feeds {
            var myfeed = feed as! [String:String]
            var currAnnouncement = [String:Any]()
            currAnnouncement["title"] = myfeed["title"]
            currAnnouncement["link"] = myfeed["link"]
            currAnnouncement["description"] = myfeed["description"]
            currAnnouncement["pubDate"] = dateFormatter.date(from: (myfeed["pubDate"]!) )
            currAnnouncement["tag"] = "none"
            
            announcementList.append(currAnnouncement)
        }
    }
    
    func test(){
        fetchAnnouncements()
    }
}

