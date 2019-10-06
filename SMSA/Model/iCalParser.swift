//
//  CalendarModel.swift
//  SMSAcalendar
//
/// Used and modified under the MIT License from: https://github.com/kiliankoe/iCalKit/
/* This is the top level iCal Parser class. The rest of the classes can be found
 in the iCal Parser Helpers. This is the class the view controller instantiates
 to populate the CalendarViewController.
 
 Execution begins with
 */

import Foundation

class iCalParser{

    static let icp = iCalParser.init()
    public var upcomingEvents = [[String:Any]]()
    public var upcomingEventsWithDates = [[String:Any]]()

    private init(){
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_8b69l0kh8jgun6e2ja9cuk7k9g%40group.calendar.google.com/public/basic.ics", calName: "Liturgical Services")
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_frhtdi64stbshp3a6phcc10sds%40group.calendar.google.com/public/basic.ics", calName: "The Upper Room College Meeting")
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_fgrkicacmu4lghh22tudfufg8c%40group.calendar.google.com/public/basic.ics", calName: "St. Moses Arabic Youth Meeting")
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_o1oq4dfbt5994n6uigck1s5svs%40group.calendar.google.com/public/basic.ics", calName: "Lazarus Project")
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_uiq2ebabvqqh1jvf5uv7maa6pc%40group.calendar.google.com/public/basic.ics", calName: "High School")
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_8fufoct89ff3omsrbsb2ppk02c%40group.calendar.google.com/public/basic.ics", calName: "Junior High Boys")
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_kto09omm4s9sc5pc7hvgrlc308%40group.calendar.google.com/public/basic.ics", calName: "Junior High Girls")
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_fgsat5acju97gokehji86kipho%40group.calendar.google.com/public/basic.ics", calName: "Elementary")
        addUpcomingEventsFrom(url: "https://calendar.google.com/calendar/ical/st-athanasius.org_jjrv7tefiiohgs61hcbkt2e6ro%40group.calendar.google.com/public/basic.ics", calName: "Graduate Bible Study")
        
        addDates()
    }
    
    /// This function returns an Array of Dictionaries, with each dictionary representing one event. Keys for dictionary found below.
    func getUpcomingEvents() -> [[String:Any]]{
        return upcomingEvents
    }
    
    /// Description
    /// - Parameter url: Public URL for Calendar in iCal Format
    /// - Parameter calName: Name of the Calendar (doesn't have to match name in iCal file)
    func addUpcomingEventsFrom(url: String, calName: String){
        let myURL = URL.init(string: url)!
        do{
            let y = try iCal.load(url: myURL)
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
    
    /// Prints Upcoming Events (Title Only)- useful for debugging
    func printUpcomingEvents(){
        for event in upcomingEvents{
            print(event["title"])
            print(event["start"])
        }
    }
    
    /// Prints Upcoming Events- useful for debugging
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

