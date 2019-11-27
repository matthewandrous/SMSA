//
//  AnnouncmentsModel.swift
//  SermonParser
//
//  Created by Matthew Androus on 7/19/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

import Foundation
class SermonsModel {
    
    
    static let sermonsModel = SermonsModel.init()
    var sermonList = [[String:Any]]()
    var selectedSermon = [String:Any]()
    var selectedSermonIndex: Int?
    var lastSelectedSermonIndex: Int?
    var lastProgress: Double?
    var sameSermonSelected = false
    
    private init(){
        //        print("hello world")
    }
    
    func selectSermon(index: Int){
        print("selectSermon called")
        lastSelectedSermonIndex = selectedSermonIndex
        selectedSermonIndex = index
        selectedSermon = sermonList[index]
        sermonList[index]["inProgress"] = true
        
        if lastSelectedSermonIndex == selectedSermonIndex {
            print("they selected the same one!")
            sameSermonSelected = true
        } else {
            sameSermonSelected = false
            if  lastSelectedSermonIndex != nil{
                sermonList[lastSelectedSermonIndex!]["inProgress"] = false
                print("setting old one to false")
            }
        }
    }
    
    func fetchSermons(){
        
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "E, d MMM yyy HH:mm:ss Z"
        
        let myparser = RSSParser()
        myparser.initWithURL(URL(string: "https://www.st-athanasius.org/recorded-sermons?format=rss")!)

        
        
        for (index, feed) in myparser.feeds.enumerated(){
            var myfeed = feed as! [String:String]
            var currSermon = [String:Any]()
            currSermon["title"] = myfeed["title"]
            currSermon["url"] = myparser.img[index]
            currSermon["image"] = myparser.img2[index]
            print(myparser.img2[index])
//            currSermon["description"] = myfeed["description"]
            currSermon["pubDate"] = dateFormatter.date(from: (myfeed["pubDate"]!) )
            currSermon["inProgress"] = false
            //            print(currSermon["pubDate"]!)
//            currSermon["tag"] = "none"
            sermonList.append(currSermon)
        }
        
        
//        for curr in myparser.img{
//            print (curr)
//        }
    }
    
    func test(){
        fetchSermons()
    }
}

