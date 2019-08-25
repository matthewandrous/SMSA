//
//  CalendarModel.swift
//  SMSAcalendar
//
//  Created by Matthew Androus on 8/21/19.
//  Copyright © 2019 SMSA Devs. All rights reserved.
//

import Foundation

class iCalParser{

    static let icp = iCalParser.init()
    public var upcomingEvents = [[String:Any]]()
    public var upcomingEventsWithDates = [[String:Any]]()

    private init(){
        print("hello world")
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_8b69l0kh8jgun6e2ja9cuk7k9g%40group.calendar.google.com/public/basic.ics", calName: "Liturgical Services")
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_frhtdi64stbshp3a6phcc10sds%40group.calendar.google.com/public/basic.ics", calName: "The Upper Room College Meeting")
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_fgrkicacmu4lghh22tudfufg8c%40group.calendar.google.com/public/basic.ics", calName: "St. Moses Arabic Youth Meeting")
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_o1oq4dfbt5994n6uigck1s5svs%40group.calendar.google.com/public/basic.ics", calName: "Lazarus Project")
        addDates()
        printUpcomingEvents()
        printUpcomingEventsWithDates()
    }
    
    func getUpcomingEvents() -> [[String:Any]]{
        return upcomingEvents
    }
    
    func addUpcomingEventsFrom(url: String, calName: String){
        let myURL = URL.init(string: url)!
        do{
            let y = try iCal.load(url: myURL)
            print("PRINTING Y")
            for event in y.eventList{
                if event.upcomingOccurences.count != 0{
                    print (event.title)
                    for occ in event.upcomingOccurences{
                        var currEvent = [String:Any]()
                        currEvent["title"] = event.title
                        currEvent["start"] = occ["start"]
                        currEvent["end"] = occ["end"]
                        currEvent["calName"] = calName
                        upcomingEvents.append(currEvent)
                        print(occ.description)
                    }
                    print()
                }
            }
            
            upcomingEvents.sort { ($0["start"]! as! Date) < ($1["start"]! as! Date) }
            
            
        } catch{
            print("there was an error")
        }
    }
    
    func printUpcomingEvents(){
        for event in upcomingEvents{
            print(event["title"])
            print(event["start"])
        }
    }
    
    func printUpcomingEventsWithDates(){
        print("HERE COME THE UPCOMING EVENTS")
        print()
        for entry in upcomingEventsWithDates{
            if entry["type"] as! String == "event"{
                print(entry["title"])
                print(entry["start"])
            } else {
                print(entry["day"])
                print(entry["date"])
            }
        }
        print(Date.init())
    }
    
    func doNothing(){
        
    }
    
    func addDates(){
        var lastDate = Date.init(timeIntervalSince1970: 0)
        lastDate = removeTimeStamp(fromDate: lastDate)
        
        //day of week formatter
        let dayOfWeekFromatter = DateFormatter()
        let monthFormatter = DateFormatter()
        monthFormatter.dateFormat = "yyyy/MM/dd"
        monthFormatter.timeZone = .current
        
        let timeFormatter = DateFormatter()
        timeFormatter.dateFormat = "HH:mm"
        timeFormatter.timeZone = .current
        
        
        for event in upcomingEvents{
            var dateWithoutTime = removeTimeStamp(fromDate: event["start"] as! Date)
            if(dateWithoutTime != lastDate){
               
                var dateEntry = [String:Any]()
                dateEntry["type"] = "date"
                dateEntry["day"] = String(dayOfWeekFromatter.weekdaySymbols[Calendar.current.component(.weekday, from: event["start"] as! Date)-1])
                dateEntry["date"] = String(monthFormatter.string(from: event["start"] as! Date))
                upcomingEventsWithDates.append(dateEntry)
                
                var eventEntry = [String:Any]()
                eventEntry["type"] = "event"
                eventEntry["title"] = event["title"]
                eventEntry["start"] = timeFormatter.string(from: event["start"] as! Date).description
                eventEntry["end"] = timeFormatter.string(from: event["end"] as! Date).description
                eventEntry["calName"] = event["calName"]
                upcomingEventsWithDates.append(eventEntry)
                lastDate = removeTimeStamp(fromDate: event["start"] as! Date)
            } else {
                var eventEntry = [String:Any]()
                eventEntry["type"] = "event"
                eventEntry["title"] = event["title"]
                eventEntry["start"] = timeFormatter.string(from: event["start"] as! Date).description
                eventEntry["end"] = timeFormatter.string(from: event["end"] as! Date).description
                eventEntry["calName"] = event["calName"]
                upcomingEventsWithDates.append(eventEntry)
            }
        }
    }
    
    public func removeTimeStamp(fromDate: Date) -> Date {
        guard let date = Calendar.current.date(from: Calendar.current.dateComponents([.year, .month, .day], from: fromDate)) else {
            fatalError("Failed to strip time from Date object")
        }
        return date
    }
}

