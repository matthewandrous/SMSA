//
//  XEvent.swift
//  SMSAcalendar
//
/// Used and modified under the MIT License from: https://github.com/kiliankoe/iCalKit/

import Foundation

class XEvent {
    //parsed variables
    public var summary:String? = nil
    public var dtstart:String? = nil
    public var dtend:String? = nil
    public var rrule:String? = nil
    
    //useful variables
    public var title:String? = nil
    public var start:Date? = nil
    public var end:Date? = nil
    
    public var freq:String? = nil
    public var until:Date? = nil
    public var count:Int? = nil
    public var byDay:String? = nil
    
    //will list any dates this event occurs for the next two weeks
    public var upcomingOccurences = [[String:Date]]()
    
    public init(){
        print("new event created")
    }
    
    public init(summary: String, dtstart: String, dtend: String, rrule: String){
        print("new event created with parsed values")
        self.summary = summary
        self.dtstart = dtstart
        self.dtend = dtend
        self.rrule = rrule
        
        self.title = summary
        
        //set up date formatter
        let dateFormatter = DateFormatter()
        dateFormatter.dateFormat = "yyyyMMddHHmmss"
        dateFormatter.timeZone = .current
        dateFormatter.timeZone = TimeZone(secondsFromGMT: -25200)
        
        //store start time Date() object
        self.dtstart = self.dtstart?.replacingOccurrences(of: "T", with: "")
        self.dtstart = self.dtstart?.replacingOccurrences(of: "Z", with: "")
        self.dtstart = self.dtstart?.replacingOccurrences(of: "\r", with: "")
        //print (self.dtstart)
        start = dateFormatter.date(from: self.dtstart!)
        //print(start?.description)
        
        //store end time Date() object
        self.dtend = self.dtend?.replacingOccurrences(of: "T", with: "")
        self.dtend = self.dtend?.replacingOccurrences(of: "Z", with: "")
        self.dtend = self.dtend?.replacingOccurrences(of: "\r", with: "")
        //print (self.dtend)
        end = dateFormatter.date(from: self.dtend!)
        //print(end?.description)
        
        
        if(rrule != "none"){
            var splitRrule = rrule.split(separator: ";")
            
            for currRule in splitRrule{
                var splitCurrRule = currRule.split(separator: "=")
                var field = String(splitCurrRule[0])
                var data = String(splitCurrRule[1])
                
                switch field{
                case "FREQ":
                    data = data.replacingOccurrences(of: "\r", with: "")
                    freq = data
                    continue
                case "UNTIL": //TODO CONVERT THIS TO AN ACTUAL DATE
                    data = data.replacingOccurrences(of: "T", with: "")
                    data = data.replacingOccurrences(of: "Z", with: "")
                    data = data.replacingOccurrences(of: "\r", with: "")
                    until = dateFormatter.date(from: data)
                    continue
                case "BYDAY":
                    data = data.replacingOccurrences(of: "\r", with: "")
                    byDay = data
                    continue
                case "COUNT":
                    data = data.replacingOccurrences(of: "\r", with: "")
                    count = Int(data)
                    continue
                default:
                    break
                }
            }
        } else {
            print ("rrule was nil")
        }

        
        populateUpcoming()
        printInfo()
    }
    
    func populateUpcoming(){
        var doneChecking = false
        
        if until != nil {
            if until! < Date.init(){
                return
            }
        }
        
        //WEEKLY RULE
        if freq == "WEEKLY"  {
            var iteration = 1
            print("This is a weekly event")
            while !doneChecking{
                
                if start! < Date.init(){ //if date is still in past
                    start = start?.addingTimeInterval(604800)
                    iteration += 1
                } else {
                    if start! > Date.init().addingTimeInterval(2*604800){ //if date is more than two weeks in the future
                        doneChecking = true
                    } else { //date must be in our two week window
                        if until != nil {
                            if until! < start!{
                                return
                            }
                        }
                        
                        if count != nil{
                            if iteration > count!{
                                return
                            }
                        }
                        
                        print("upcoming occurance at: " + (self.start?.description)!)
                        var tempDic = [String:Date]()
                        tempDic["start"] = start
                        tempDic["end"] = end
                        upcomingOccurences.append(tempDic)
                        start = start?.addingTimeInterval(604800)
                        iteration += 1
                    }
                }
            }
        }
    }
    
    func printInfo(){
        print("Event Title: " + title!)
        if(freq != nil){
            print("Event Freq: " + freq!)
        }
        if(until != nil){
            print("Event until: " + until!.description)
        }
    }
}
