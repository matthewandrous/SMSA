//
//  AnnouncementModel.swift
//  AnnouncementParser
//
//  Created by Matthew Androus on 7/19/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

/* This class is the RSS Parser. It is used twice in the application.
 Frist, it is used to parse the RSS feeds for the announcements.
 Second, it is used to parse the RSS feed for the recorded sermons.
 
 While we wrote most of this ourselves, we couldn't have done it without the many
 programmers who have shared their expertise on GitHub and StackOverflow. Much love!
 */

import Foundation

class RSSParser: NSObject, XMLParserDelegate {
    
    var parser = XMLParser()
    var feeds = NSMutableArray()
    var elements = NSMutableDictionary()
    var element = NSString()
    var ftitle = NSMutableString()
    var link = NSMutableString()
    var img:  [AnyObject] = []
    var img2:  [AnyObject] = [] //TODO
    var fdescription = NSMutableString() //TODO
    var fdate = NSMutableString() //TODO
    
    // initilise parser
    func initWithURL(_ url :URL) -> AnyObject {
        startParse(url)
        return self
    }
    
    func startParse(_ url :URL) {
        feeds = []
        parser = XMLParser(contentsOf: url)!
        parser.delegate = self
        parser.shouldProcessNamespaces = false
        parser.shouldReportNamespacePrefixes = true
        parser.shouldResolveExternalEntities = false
        parser.parse()
    }
    
    func allFeeds() -> NSMutableArray {
        return feeds
    }
    
    func parser(_ parser: XMLParser, didStartElement elementName: String, namespaceURI: String?, qualifiedName qName: String?, attributes attributeDict: [String : String]) {
        element = elementName as NSString
        print(element)
        if (element as NSString).isEqual(to: "item") {
            elements =  NSMutableDictionary()
            elements = [:]
            ftitle = NSMutableString()
            ftitle = ""
            link = NSMutableString()
            link = ""
            fdescription = NSMutableString()
            fdescription = ""
            fdate = NSMutableString()
            fdate = ""
        } else if (element as NSString).isEqual(to: "enclosure") {
            print(attributeDict["url"])
            if let urlString = attributeDict["url"] {
                img.append(urlString as AnyObject)
            }
        } else if (element as NSString).isEqual(to: "itunes:image") {
            print(attributeDict["href"])
            if let urlString = attributeDict["href"] {
                img2.append(urlString as AnyObject)
            }
        }
    }
    
    func parser(_ parser: XMLParser, didEndElement elementName: String, namespaceURI: String?, qualifiedName qName: String?) {
        print("2")
        print(elementName)
        if (elementName as NSString).isEqual(to: "item") {
            if ftitle != "" {
                elements.setObject(ftitle, forKey: "title" as NSCopying)
            }
            
            if link != "" {
                elements.setObject(link, forKey: "link" as NSCopying)
            }
            
            if fdescription != "" {
                elements.setObject(fdescription, forKey: "description" as NSCopying)
            }
            
            if fdate != "" {
                elements.setObject(fdate, forKey: "pubDate" as NSCopying)
            }
            
            feeds.add(elements)
        }
    }
    
    func parser(_ parser: XMLParser, foundCharacters string: String) {
        if element.isEqual(to: "title") {
            ftitle.append(string)
        } else if element.isEqual(to: "link") {
            link.append(string)
        } else if element.isEqual(to: "description") {
            fdescription.append(string)
        } else if element.isEqual(to: "pubDate") {
            fdate.append(string)
        } else if element.isEqual(to: "enclosure") {
            print(string)
        } else if element.isEqual(to: "itunes:image") {
            print(string)
        }
    }
}
